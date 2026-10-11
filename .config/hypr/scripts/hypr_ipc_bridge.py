#!/usr/bin/env python3
# =============================================================================
# Hyprland IPC Compatibility Bridge for Lua Provider
# Translates legacy commands (dispatch workspace N, movetoworkspace, etc.)
# into valid Hyprland 0.56 Lua dispatch calls for Waybar and other tools.
# =============================================================================
import asyncio
import os
import signal
import sys
import re

SIG = os.environ.get("HYPRLAND_INSTANCE_SIGNATURE")
if not SIG:
    # Try finding the latest signature in /run/user/UID/hypr/
    uid = os.getuid()
    hypr_dir = f"/run/user/{uid}/hypr"
    try:
        sigs = [d for d in os.listdir(hypr_dir) if os.path.isdir(os.path.join(hypr_dir, d))]
        if sigs:
            sigs.sort(key=lambda s: os.path.getmtime(os.path.join(hypr_dir, s)), reverse=True)
            SIG = sigs[0]
    except Exception:
        pass

if not SIG:
    sys.exit("Error: HYPRLAND_INSTANCE_SIGNATURE not found")

SOCK_DIR = f"/run/user/{os.getuid()}/hypr/{SIG}"
SOCK_ORIG = f"{SOCK_DIR}/.socket.sock"
SOCK_REAL = f"{SOCK_DIR}/.socket_real.sock"

WORKSPACE_RE = re.compile(rb'^dispatch\s+workspace\s+(\d+)\s*$')
MOVETOWS_RE = re.compile(rb'^dispatch\s+movetoworkspace\s+(\d+)\s*$')
KILL_RE = re.compile(rb'^dispatch\s+killactive\s*$')

def cleanup():
    if os.path.exists(SOCK_ORIG):
        try:
            os.unlink(SOCK_ORIG)
        except Exception:
            pass
    if os.path.exists(SOCK_REAL):
        try:
            os.rename(SOCK_REAL, SOCK_ORIG)
        except Exception:
            pass

def sig_handler(signum, frame):
    cleanup()
    sys.exit(0)

signal.signal(signal.SIGINT, sig_handler)
signal.signal(signal.SIGTERM, sig_handler)

async def handle_client(reader, writer):
    try:
        data = await reader.read(65536)
        if not data:
            writer.close()
            return

        # Проверяем команду и при необходимости переводим в Lua-диспатчер
        m = WORKSPACE_RE.match(data.strip())
        if m:
            ws_id = m.group(1).decode()
            data = f"dispatch hl.dsp.focus({{ workspace = {ws_id} }})\n".encode()
        else:
            m = MOVETOWS_RE.match(data.strip())
            if m:
                ws_id = m.group(1).decode()
                data = f"dispatch hl.dsp.window.move({{ workspace = {ws_id} }})\n".encode()
            elif KILL_RE.match(data.strip()):
                data = b"dispatch hl.dsp.window.close()\n"

        # Проксируем к настоящему сокету Hyprland
        r_real, w_real = await asyncio.open_unix_connection(SOCK_REAL)
        w_real.write(data)
        await w_real.drain()

        resp = await r_real.read(65536)
        writer.write(resp)
        await writer.drain()

        w_real.close()
        await w_real.wait_closed()
    except Exception:
        pass
    finally:
        try:
            writer.close()
            await writer.wait_closed()
        except Exception:
            pass

async def main():
    # Если .socket_real.sock еще не существует, переименовываем оригинальный сокет
    if not os.path.exists(SOCK_REAL):
        if os.path.exists(SOCK_ORIG):
            os.rename(SOCK_ORIG, SOCK_REAL)
        else:
            sys.exit(f"Original socket {SOCK_ORIG} does not exist")
    else:
        # Если оригинальный сокет остался от старого прокси, удаляем
        if os.path.exists(SOCK_ORIG):
            os.unlink(SOCK_ORIG)

    server = await asyncio.start_unix_server(handle_client, path=SOCK_ORIG)
    # Выставляем права доступа
    os.chmod(SOCK_ORIG, 0o755)

    try:
        async with server:
            await server.serve_forever()
    finally:
        cleanup()

if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        cleanup()

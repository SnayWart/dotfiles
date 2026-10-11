#!/usr/bin/env bash
# =============================================================================
# OpenRC / D-Bus Daemons Launcher (Cold Boot & Session Safe)
# =============================================================================

# 1. Ждем появления Wayland-сокета от Hyprland
for i in {1..50}; do
    SOCKET=$(ls -t /run/user/$UID/wayland-[0-9]* 2>/dev/null | head -n 1)
    if [ -n "$SOCKET" ] && [ -S "$SOCKET" ]; then
        export WAYLAND_DISPLAY=$(basename "$SOCKET")
        break
    fi
    sleep 0.1
done

# Небольшая пауза для завершения регистрации дисплея и слоев
sleep 0.4

# 2. Получаем актуальный D-Bus адрес сессии
if [[ "$DBUS_SESSION_BUS_ADDRESS" == "disabled:"* || -z "$DBUS_SESSION_BUS_ADDRESS" ]]; then
    HYPR_PID=$(pgrep -u $UID -x Hyprland | head -n 1)
    if [ -n "$HYPR_PID" ]; then
        HYPR_DBUS=$(grep -z '^DBUS_SESSION_BUS_ADDRESS=' /proc/$HYPR_PID/environ 2>/dev/null | tr -d '\0')
        [ -n "$HYPR_DBUS" ] && export "$HYPR_DBUS"
    fi
fi

# Если D-Bus все еще не определен, запускаем персональный экземпляр
if [[ "$DBUS_SESSION_BUS_ADDRESS" == "disabled:"* || -z "$DBUS_SESSION_BUS_ADDRESS" ]]; then
    eval $(dbus-launch --sh-syntax)
fi

export DISPLAY=:0
dbus-update-activation-environment --all DISPLAY WAYLAND_DISPLAY DBUS_SESSION_BUS_ADDRESS XDG_CURRENT_DESKTOP 2>/dev/null

# 3. Запускаем IPC-мост совместимости команд (для кликов по столам в Waybar)
killall hypr_ipc_bridge.py 2>/dev/null
setsid -f ~/.config/hypr/scripts/hypr_ipc_bridge.py >/tmp/bridge.log 2>&1
sleep 0.2

# 4. Перезапускаем демоны
killall waybar mako hyprpaper hypridle 2>/dev/null
sleep 0.2

# 5. PipeWire & WirePlumber (Звук и видеопотоки захвата экрана)
if ! pgrep -x pipewire >/dev/null; then
    setsid -f pipewire >/tmp/pipewire.log 2>&1
    sleep 0.1
fi
if ! pgrep -x wireplumber >/dev/null; then
    setsid -f wireplumber >/tmp/wireplumber.log 2>&1
fi
if ! pgrep -x pipewire-pulse >/dev/null; then
    setsid -f pipewire-pulse >/tmp/pipewire-pulse.log 2>&1
fi

# 6. XDG Desktop Portals (Для записи экрана и окон в OBS / браузерах)
if ! pgrep -x xdg-desktop-portal-hyprland >/dev/null; then
    setsid -f /usr/lib/xdg-desktop-portal-hyprland >/tmp/portal-hyprland.log 2>&1
    sleep 0.2
fi
if ! pgrep -x xdg-desktop-portal >/dev/null; then
    setsid -f /usr/lib/xdg-desktop-portal >/tmp/portal.log 2>&1
fi

# 7. Запускаем фоновые службы через setsid
setsid -f ~/.config/hypr/scripts/launch_waybar.sh >/tmp/waybar.log 2>&1
setsid -f mako >/tmp/mako.log 2>&1

STATE_FILE="/home/snaywart/.config/hypr/.current_wallpaper"
CURR_WP=$(cat "$STATE_FILE" 2>/dev/null)
if [[ "$CURR_WP" == *.mp4 || "$CURR_WP" == *.webm ]]; then
    setsid -f mpvpaper -o "no-audio --loop" DP-1 "$CURR_WP" >/tmp/mpvpaper.log 2>&1
else
    setsid -f hyprpaper -c /home/snaywart/.config/hypr/hyprpaper.conf >/tmp/hyprpaper.log 2>&1
fi

setsid -f hypridle >/dev/null 2>&1

setsid -f wl-paste --type text --watch cliphist store >/dev/null 2>&1
setsid -f wl-paste --type image --watch cliphist store >/dev/null 2>&1


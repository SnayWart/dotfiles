#!/usr/bin/env bash
# =============================================================================
# Waybar Robust Session Wrapper
# =============================================================================

# Гарантируем корректный D-Bus адрес из окружения Hyprland
if [[ "$DBUS_SESSION_BUS_ADDRESS" == "disabled:"* || -z "$DBUS_SESSION_BUS_ADDRESS" ]]; then
    HYPR_PID=$(pgrep -u $UID -x Hyprland | head -n 1)
    if [ -n "$HYPR_PID" ]; then
        HYPR_DBUS=$(grep -z '^DBUS_SESSION_BUS_ADDRESS=' /proc/$HYPR_PID/environ 2>/dev/null | tr -d '\0')
        [ -n "$HYPR_DBUS" ] && export "$HYPR_DBUS"
    fi
fi

# Убедимся, что WAYLAND_DISPLAY задан
if [ -z "$WAYLAND_DISPLAY" ]; then
    SOCKET=$(ls -t /run/user/$UID/wayland-[0-9]* 2>/dev/null | head -n 1)
    [ -n "$SOCKET" ] && export WAYLAND_DISPLAY=$(basename "$SOCKET")
fi

exec waybar "$@"

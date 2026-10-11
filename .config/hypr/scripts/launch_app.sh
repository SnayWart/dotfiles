#!/usr/bin/env bash
# =============================================================================
# Smart Cascade App Launcher (1 Window per Workspace Rule)
# =============================================================================
APP="$1"
shift
ARGS="$@"

[ -z "$APP" ] && exit 1

# D-Bus окружение для надежной работы уведомлений
if [[ "$DBUS_SESSION_BUS_ADDRESS" == "disabled:"* || -z "$DBUS_SESSION_BUS_ADDRESS" ]]; then
    HYPR_PID=$(pgrep -u $UID -x Hyprland | head -n 1)
    if [ -n "$HYPR_PID" ]; then
        HYPR_DBUS=$(grep -z '^DBUS_SESSION_BUS_ADDRESS=' /proc/$HYPR_PID/environ 2>/dev/null | tr -d '\0')
        [ -n "$HYPR_DBUS" ] && export "$HYPR_DBUS"
    fi
fi

# Окружение тем оформления
export GTK_THEME="Adwaita:dark"

# Определяем текущий рабочий стол
CURRENT_WS=$(hyprctl monitors -j | jq '.[0].activeWorkspace.id // 1' 2>/dev/null)

# Получаем информацию обо всех рабочих столах
WS_JSON=$(hyprctl workspaces -j 2>/dev/null)

# Количество окон на текущем столе
CURRENT_WINS=$(echo "$WS_JSON" | jq ".[] | select(.id == $CURRENT_WS) | .windows" 2>/dev/null)

TARGET_WS=$CURRENT_WS

# Если текущий стол занят - каскадно ищем следующий абсолютно свободный стол
if [ -n "$CURRENT_WINS" ] && [ "$CURRENT_WINS" -gt 0 ]; then
    FOUND=0
    # Сначала проверяем следующие столы от (CURRENT_WS + 1) до 10
    START=$((CURRENT_WS + 1))
    if [ "$START" -le 10 ]; then
        for ws in $(seq $START 10); do
            WINS=$(echo "$WS_JSON" | jq ".[] | select(.id == $ws) | .windows" 2>/dev/null)
            if [ -z "$WINS" ] || [ "$WINS" -eq 0 ]; then
                TARGET_WS=$ws
                FOUND=1
                break
            fi
        done
    fi

    # Если до 10 все занято, ищем свободный от 1 до 10
    if [ "$FOUND" -eq 0 ]; then
        for ws in {1..10}; do
            WINS=$(echo "$WS_JSON" | jq ".[] | select(.id == $ws) | .windows" 2>/dev/null)
            if [ -z "$WINS" ] || [ "$WINS" -eq 0 ]; then
                TARGET_WS=$ws
                FOUND=1
                break
            fi
        done
    fi
fi

# Мягкое уведомление через Mako
APP_NAME=$(basename "$APP")
notify-send -a "Hyprland" -i "preferences-desktop-display" \
    "Рабочий стол №${TARGET_WS}" \
    "󰮯 Окно ${APP_NAME} открыто на ${TARGET_WS} рабочем столе" 2>/dev/null

# Удаляем старый токен рабочего стола, чтобы окно не привязывалось к предыдущему столу
unset HL_INITIAL_WORKSPACE_TOKEN

# Формируем команду с жестким правилом запуска на целевом столе [workspace N]
if [ -n "$ARGS" ]; then
    DISPATCH_CMD="[workspace $TARGET_WS] $APP $ARGS"
else
    DISPATCH_CMD="[workspace $TARGET_WS] $APP"
fi

# Запускаем через встроенный диспатчер Hyprland
hyprctl dispatch "hl.dsp.exec_cmd(\"$DISPATCH_CMD\")"

# Переводим фокус на целевой рабочий стол
hyprctl dispatch "hl.dsp.focus({ workspace = $TARGET_WS })"

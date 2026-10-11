#!/usr/bin/env bash
# =============================================================================
# Soft Pastel Dropdown Power Menu for Hyprland & Waybar
# =============================================================================

OPT_SHUTDOWN="󰐥  Выключить компьютер"
OPT_REBOOT="󰜉  Перезагрузить"
OPT_SUSPEND="󰤄  Спящий режим"
OPT_LOCK="󰌾  Заблокировать экран"
OPT_LOGOUT="󰈆  Завершить сеанс"

CHOICE=$(echo -e "${OPT_SHUTDOWN}\n${OPT_REBOOT}\n${OPT_SUSPEND}\n${OPT_LOCK}\n${OPT_LOGOUT}" | rofi -dmenu \
    -theme ~/.config/rofi/power.rasi \
    -p "  Меню питания ")

case "$CHOICE" in
    "$OPT_SHUTDOWN")
        loginctl poweroff
        ;;
    "$OPT_REBOOT")
        loginctl reboot
        ;;
    "$OPT_SUSPEND")
        loginctl suspend
        ;;
    "$OPT_LOCK")
        hyprlock
        ;;
    "$OPT_LOGOUT")
        killall -9 Hyprland
        ;;
esac

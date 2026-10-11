#!/usr/bin/env bash
# =============================================================================
# Control Center / Quick Settings (End-4 Style) for Hyprland
# =============================================================================
SCRIPTS="$HOME/.config/hypr/scripts"

# Получаем текущие параметры системы
VOL_RAW=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)
VOL_PCT=$(echo "$VOL_RAW" | awk '{print int($2 * 100)}')
[ -z "$VOL_PCT" ] && VOL_PCT="0"
if echo "$VOL_RAW" | grep -q "MUTED"; then
    VOL_STR="󰝟 [Mute] ${VOL_PCT}%"
else
    VOL_STR="󰕾 ${VOL_PCT}%"
fi

WIFI_SSID=$(iwctl station wlan0 show 2>/dev/null | grep -i "Connected network" | awk '{$1=$2=""; print $0}' | xargs)
[ -z "$WIFI_SSID" ] && WIFI_SSID="Офлайн"

WP_CURR=$(grep -m1 'path =' "$HOME/.config/hypr/hyprpaper.conf" 2>/dev/null | awk -F'/' '{print $NF}')
[ -z "$WP_CURR" ] && WP_CURR="autumn_kemono.jpg"

HEADER="Звук: ${VOL_STR} | Wi-Fi: ${WIFI_SSID}\nОбои: ${WP_CURR}"

OPT_WP="󰸉  Галерея обоев (Autumn Kemono)"
OPT_VOL="󰕾  Громкость звука (${VOL_PCT}%)"
OPT_MIC="󰍬  Микрофон (Mute / Unmute)"
OPT_WIFI="󰤨  Wi-Fi сети (${WIFI_SSID})"
OPT_LAYOUT="󰌌  Раскладка клавиатуры (Сменить)"
OPT_SHOT_AREA="󰔎  Скриншот области"
OPT_SHOT_FULL="󰹑  Скриншот всего экрана"
OPT_CLIP="  История буфера обмена"
OPT_FILES="󰉋  Файловый менеджер (Thunar)"
OPT_TERM="󰞷  Терминал (Kitty)"
OPT_POWER="  Меню питания"

CHOICE=$(echo -e "${OPT_WP}\n${OPT_VOL}\n${OPT_MIC}\n${OPT_WIFI}\n${OPT_LAYOUT}\n${OPT_SHOT_AREA}\n${OPT_SHOT_FULL}\n${OPT_CLIP}\n${OPT_FILES}\n${OPT_TERM}\n${OPT_POWER}" | rofi -dmenu \
    -theme ~/.config/rofi/control_center.rasi \
    -p " 󰄛 Центр управления " \
    -mesg "$HEADER")

case "$CHOICE" in
    "$OPT_WP")
        "$SCRIPTS/wallpapers.sh"
        ;;
    "$OPT_VOL")
        # Быстрый выбор уровня громкости
        V_CHOICE=$(echo -e "󰕾 100%\n󰖀 75%\n󰖀 50%\n󰕿 25%\n󰝟 Без звука (Mute)" | rofi -dmenu \
            -theme ~/.config/rofi/control_center.rasi \
            -p " 󰕾 Уровень звука " \
            -mesg "Текущая громкость: ${VOL_PCT}%")
        case "$V_CHOICE" in
            *"100%"*) wpctl set-volume @DEFAULT_AUDIO_SINK@ 1.0; wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 ;;
            *"75%"*)  wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.75; wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 ;;
            *"50%"*)  wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.50; wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 ;;
            *"25%"*)  wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.25; wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 ;;
            *"Mute"*) wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
        esac
        ;;
    "$OPT_MIC")
        wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
        notify-send -i "audio-input-microphone" "Микрофон" "Состояние изменено"
        ;;
    "$OPT_WIFI")
        "$SCRIPTS/wifi_menu.sh"
        ;;
    "$OPT_LAYOUT")
        hyprctl switchxkblayout all next
        notify-send -i "input-keyboard" "Раскладка" "Язык ввода переключен"
        ;;
    "$OPT_SHOT_AREA")
        "$SCRIPTS/screenshot.sh" area
        ;;
    "$OPT_SHOT_FULL")
        "$SCRIPTS/screenshot.sh" full
        ;;
    "$OPT_CLIP")
        "$SCRIPTS/clipmanager.sh"
        ;;
    "$OPT_FILES")
        "$SCRIPTS/launch_app.sh" thunar
        ;;
    "$OPT_TERM")
        "$SCRIPTS/launch_app.sh" kitty
        ;;
    "$OPT_POWER")
        "$SCRIPTS/power_menu.sh"
        ;;
esac

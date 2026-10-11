#!/usr/bin/env bash
# =============================================================================
# Soft Pastel Autumn Wi-Fi Dropdown Popup for Waybar
# =============================================================================

# D-Bus окружение для уведомлений Mako
if [[ "$DBUS_SESSION_BUS_ADDRESS" == "disabled:"* || -z "$DBUS_SESSION_BUS_ADDRESS" ]]; then
    HYPR_PID=$(pgrep -u $UID -x Hyprland | head -n 1)
    if [ -n "$HYPR_PID" ]; then
        HYPR_DBUS=$(grep -z '^DBUS_SESSION_BUS_ADDRESS=' /proc/$HYPR_PID/environ 2>/dev/null | tr -d '\0')
        [ -n "$HYPR_DBUS" ] && export "$HYPR_DBUS"
    fi
fi

THEME="$HOME/.config/rofi/wifi.rasi"

# Проверяем состояние радиомодуля Wi-Fi
WIFI_STATE=$(nmcli -fields WIFI g 2>/dev/null | tail -n 1 | tr -d ' ')

if [ "$WIFI_STATE" = "disabled" ]; then
    CHOICE=$(echo -e "󰤨  Включить Wi-Fi\n󰅖  Закрыть" | rofi -dmenu -theme "$THEME" -p " 󰤮 Wi-Fi " -mesg "Беспроводной модуль сейчас выключен")
    if [ "$CHOICE" = "󰤨  Включить Wi-Fi" ]; then
        nmcli radio wifi on
        notify-send -a "Wi-Fi" -i "network-wireless" "Wi-Fi" "Беспроводной модуль включен 󰤨"
        sleep 1
        exec "$0"
    fi
    exit 0
fi

# Получаем текущее активное подключение
CURRENT_INFO=$(nmcli -t -f active,ssid,signal dev wifi 2>/dev/null | grep '^yes:' | head -n 1)
CURRENT_SSID=$(echo "$CURRENT_INFO" | cut -d: -f2)
CURRENT_SIGNAL=$(echo "$CURRENT_INFO" | cut -d: -f3)

# IP-адрес интерфейса wlan0
IP_ADDR=$(ip -4 addr show wlan0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n 1)

if [ -n "$CURRENT_SSID" ]; then
    HEADER="󰤨 ${CURRENT_SSID} (${CURRENT_SIGNAL:-0}%) • IP: ${IP_ADDR:-Ожидание}"
else
    HEADER="󰤭 Нет активного подключения к Wi-Fi"
fi

# Формируем список действий и доступных сетей
OPTIONS=""

# 1. Быстрые системные действия
if [ -n "$CURRENT_SSID" ]; then
    OPTIONS+="󰅖  Отключиться от [${CURRENT_SSID}]\n"
fi
OPTIONS+="󰤭  Выключить Wi-Fi\n"
OPTIONS+="󰑐  Обновить список сетей\n"

# 2. Список доступных сетей в формате -t (разделитель двоеточие)
NETWORKS_RAW=$(nmcli -t -f active,ssid,signal,security dev wifi list 2>/dev/null)

SEEN_SSIDS=" "
while IFS=: read -r in_use ssid signal sec; do
    # Пропускаем пустые и скрытые сети
    [ -z "$ssid" ] && continue
    [[ "$SEEN_SSIDS" =~ " $ssid " ]] && continue
    SEEN_SSIDS+="$ssid "

    # Безопасный числовой сигнал
    SIG_NUM=${signal:-0}
    [[ "$SIG_NUM" =~ ^[0-9]+$ ]] || SIG_NUM=0

    # Иконка мощности сигнала
    if [ "$SIG_NUM" -ge 70 ]; then
        ICON="󰤨"
    elif [ "$SIG_NUM" -ge 45 ]; then
        ICON="󰤥"
    elif [ "$SIG_NUM" -ge 20 ]; then
        ICON="󰤢"
    else
        ICON="󰤟"
    fi

    # Иконка защиты
    if [[ "$sec" =~ WPA || "$sec" =~ WEP ]]; then
        LOCK="󰌾"
    else
        LOCK="󰌵"
    fi

    if [ "$in_use" = "yes" ] || [ "$in_use" = "*" ]; then
        OPTIONS+="${ICON}  ${ssid}  󰈸 [Подключено]  (${SIG_NUM}%) ${LOCK}\n"
    else
        OPTIONS+="${ICON}  ${ssid}  (${SIG_NUM}%) ${LOCK}\n"
    fi
done <<< "$NETWORKS_RAW"

# Отображаем пастельное выпадающее меню
CHOSEN=$(echo -e "$OPTIONS" | rofi -dmenu -theme "$THEME" -p " 󰤨 Wi-Fi " -mesg "$HEADER")

[ -z "$CHOSEN" ] && exit 0

# Обработка выбора
if [[ "$CHOSEN" == "󰤭  Выключить Wi-Fi"* ]]; then
    nmcli radio wifi off
    notify-send -a "Wi-Fi" -i "network-wireless-disconnected" "Wi-Fi" "Беспроводная сеть выключена"
    exit 0
elif [[ "$CHOSEN" == "󰅖  Отключиться от"* ]]; then
    nmcli dev disconnect wlan0
    notify-send -a "Wi-Fi" -i "network-wireless-disconnected" "Wi-Fi" "Отключено от ${CURRENT_SSID}"
    exit 0
elif [[ "$CHOSEN" == "󰑐  Обновить список"* ]]; then
    nmcli dev wifi rescan 2>/dev/null
    exec "$0"
fi

# Извлекаем имя выбранной сети
TARGET_SSID=$(echo "$CHOSEN" | sed -E 's/^[󰤨󰤥󰤢󰤟]  //; s/  󰈸.*//; s/  \([0-9]+%.*//; s/ +$//')

[ -z "$TARGET_SSID" ] && exit 0

if [ "$TARGET_SSID" = "$CURRENT_SSID" ]; then
    notify-send -a "Wi-Fi" -i "network-wireless" "Wi-Fi" "Вы уже подключены к сети «${TARGET_SSID}»"
    exit 0
fi

# Проверяем, есть ли уже сохраненный профиль
SAVED=$(nmcli -g NAME connection show | grep -Fx "$TARGET_SSID")

if [ -n "$SAVED" ]; then
    notify-send -a "Wi-Fi" -i "network-wireless" "Wi-Fi" "Подключение к «${TARGET_SSID}»..."
    if nmcli connection up id "$TARGET_SSID" 2>/dev/null; then
        notify-send -a "Wi-Fi" -i "network-wireless" "Успешно" "Подключено к «${TARGET_SSID}» 󰤨"
    else
        notify-send -a "Wi-Fi" -i "dialog-error" "Ошибка" "Не удалось подключиться к «${TARGET_SSID}»"
    fi
    exit 0
fi

# Запрос пароля при первой попытке подключения к защищенной сети
IS_SECURED=$(echo "$CHOSEN" | grep "󰌾")

if [ -n "$IS_SECURED" ]; then
    PASS=$(rofi -dmenu -password -theme "$THEME" -p " 󰌾 Пароль " -mesg "Введите пароль для подключения к «${TARGET_SSID}»:")
    [ -z "$PASS" ] && exit 0

    notify-send -a "Wi-Fi" -i "network-wireless" "Wi-Fi" "Подключение к «${TARGET_SSID}»..."
    if nmcli dev wifi connect "$TARGET_SSID" password "$PASS" 2>/dev/null; then
        notify-send -a "Wi-Fi" -i "network-wireless" "Успешно" "Подключено к «${TARGET_SSID}» 󰤨"
    else
        notify-send -a "Wi-Fi" -i "dialog-error" "Ошибка подключения" "Неверный пароль или таймаут сети"
    fi
else
    notify-send -a "Wi-Fi" -i "network-wireless" "Wi-Fi" "Подключение к открытой сети «${TARGET_SSID}»..."
    if nmcli dev wifi connect "$TARGET_SSID" 2>/dev/null; then
        notify-send -a "Wi-Fi" -i "network-wireless" "Успешно" "Подключено к «${TARGET_SSID}» 󰤨"
    else
        notify-send -a "Wi-Fi" -i "dialog-error" "Ошибка" "Не удалось подключиться к «${TARGET_SSID}»"
    fi
fi

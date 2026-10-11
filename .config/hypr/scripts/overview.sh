#!/usr/bin/env bash
# =============================================================================
# Task Switcher (5x2 Grid / 10 Workspaces) in end-4 style
# =============================================================================

CURRENT_WS=$(hyprctl monitors -j | jq '.[0].activeWorkspace.id // 1' 2>/dev/null)
CLIENTS_JSON=$(hyprctl clients -j 2>/dev/null)

ENTRIES=""
for i in {1..10}; do
    # Находим клиента на этом рабочем столе
    CLIENT=$(echo "$CLIENTS_JSON" | jq -r ".[] | select(.workspace.id == $i) | \"\(.class)||\(\.title)\"" | head -n 1)
    
    if [ -n "$CLIENT" ]; then
        CLASS=$(echo "$CLIENT" | awk -F'||' '{print $1}')
        TITLE=$(echo "$CLIENT" | awk -F'||' '{print $2}')
        [ ${#TITLE} -gt 22 ] && TITLE="${TITLE:0:20}.."
        
        if [ "$i" -eq "$CURRENT_WS" ]; then
            ENTRIES+="${i}. ${CLASS}\n[Активен] ${TITLE}\0icon\x1f${CLASS}\x1finfo\x1f${i}\n"
        else
            ENTRIES+="${i}. ${CLASS}\n${TITLE}\0icon\x1f${CLASS}\x1finfo\x1f${i}\n"
        fi
    else
        if [ "$i" -eq "$CURRENT_WS" ]; then
            ENTRIES+="${i}. [Стол ${i}]\n[Активен] (Пусто)\0icon\x1fpreferences-desktop-display\x1finfo\x1f${i}\n"
        else
            ENTRIES+="${i}. [Стол ${i}]\n(Свободно)\0icon\x1fpreferences-system-windows\x1finfo\x1f${i}\n"
        fi
    fi
done

SELECTED=$(echo -e "$ENTRIES" | rofi -dmenu \
    -theme ~/.config/rofi/overview.rasi \
    -p " 󰮯 Рабочие столы " \
    -mesg "Сетка окон и рабочих столов (1..10) [end-4 style]:")

if [ -n "$SELECTED" ]; then
    WS_NUM=$(echo "$SELECTED" | grep -o '^[0-9]*')
    if [ -n "$WS_NUM" ]; then
        hyprctl dispatch "hl.dsp.focus({ workspace = $WS_NUM })"
    fi
fi

#!/usr/bin/env bash
# =============================================================================
# Screenshot utility with Slurp + Grim + Mako notification
# =============================================================================
MODE="$1"
DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"

FILE="$DIR/screenshot_$(date +'%Y-%m-%d_%H-%M-%S').png"

case "$MODE" in
    area)
        GEOM=$(slurp -b "#140f0c99" -c "#e6a73cff" -s "#d86b2744" -w 2)
        [ -z "$GEOM" ] && exit 0
        grim -g "$GEOM" "$FILE"
        wl-copy < "$FILE"
        notify-send -i "$FILE" "Скриншот области" "Скопирован в буфер и сохранен в ~/Pictures/Screenshots"
        ;;
    full)
        grim "$FILE"
        wl-copy < "$FILE"
        notify-send -i "$FILE" "Снимок экрана" "Сохранен в ~/Pictures/Screenshots"
        ;;
esac

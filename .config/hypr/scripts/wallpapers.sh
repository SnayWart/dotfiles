#!/usr/bin/env bash
# =============================================================================
# Interactive Wallpaper Gallery & Switcher (Hyprpaper)
# =============================================================================
WP_DIR="$HOME/.config/hypr/wallpapers"

if [ -n "$1" ] && [ -f "$1" ]; then
    WP_FILE="$1"
else
    ENTRIES=""
    for f in "$WP_DIR"/*.{jpg,png,jpeg}; do
        [ -f "$f" ] || continue
        NAME=$(basename "$f")
        ENTRIES+="${NAME}\0icon\x1f${f}\n"
    done

    CHOSEN=$(echo -en "$ENTRIES" | rofi -dmenu \
        -theme ~/.config/rofi/wallpapers.rasi \
        -p " 󰸉 Обои " \
        -mesg "Выберите обои для рабочего стола:")

    [ -z "$CHOSEN" ] && exit 0
    WP_FILE="$WP_DIR/$CHOSEN"
fi

if [ -f "$WP_FILE" ]; then
    cat << EOF > "$HOME/.config/hypr/hyprpaper.conf"
wallpaper {
    monitor = DP-1
    path = $WP_FILE
    fit_mode = cover
}
EOF
    killall hyprpaper 2>/dev/null
    sleep 0.1
    setsid -f hyprpaper -c "$HOME/.config/hypr/hyprpaper.conf" >/dev/null 2>&1
    notify-send -i "$WP_FILE" "Обои обновлены" "$(basename "$WP_FILE")"
fi

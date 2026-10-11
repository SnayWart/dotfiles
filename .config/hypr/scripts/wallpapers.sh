#!/usr/bin/env bash
# =============================================================================
# Interactive Wallpaper Gallery & Switcher (Hyprpaper & Mpvpaper)
# =============================================================================
WP_DIR="$HOME/.config/hypr/wallpapers"
THUMB_DIR="$HOME/.cache/wallpapers_thumbs"
STATE_FILE="$HOME/.config/hypr/.current_wallpaper"
mkdir -p "$THUMB_DIR"

if [ -n "$1" ] && [ -f "$1" ]; then
    WP_FILE="$1"
else
    ENTRIES=""
    for f in "$WP_DIR"/*.{jpg,png,jpeg,mp4,webm}; do
        [ -f "$f" ] || continue
        NAME=$(basename "$f")
        EXT="${NAME##*.}"
        
        # Генерация миниатюры для видео
        if [[ "$EXT" == "mp4" || "$EXT" == "webm" ]]; then
            THUMB="$THUMB_DIR/${NAME}.jpg"
            if [ ! -f "$THUMB" ]; then
                ffmpeg -y -ss 00:00:01 -i "$f" -vframes 1 -q:v 2 "$THUMB" >/dev/null 2>&1
            fi
            ICON="$THUMB"
            LABEL="󰐊 [Живые] $NAME"
        else
            ICON="$f"
            LABEL="󰸉 $NAME"
        fi
        
        ENTRIES+="${LABEL}:::${NAME}\0icon\x1f${ICON}\n"
    done

    CHOSEN_RAW=$(echo -en "$ENTRIES" | rofi -dmenu \
        -theme ~/.config/rofi/wallpapers.rasi \
        -p " 󰸉 Обои " \
        -mesg "Выберите обои (статичные или живые видео):")

    [ -z "$CHOSEN_RAW" ] && exit 0
    CHOSEN_FILE=$(echo "$CHOSEN_RAW" | awk -F':::' '{print $2}')
    WP_FILE="$WP_DIR/$CHOSEN_FILE"
fi

if [ -f "$WP_FILE" ]; then
    EXT="${WP_FILE##*.}"
    echo "$WP_FILE" > "$STATE_FILE"
    
    if [[ "$EXT" == "mp4" || "$EXT" == "webm" ]]; then
        # Живые обои через mpvpaper
        killall hyprpaper 2>/dev/null
        killall mpvpaper 2>/dev/null
        sleep 0.1
        setsid -f mpvpaper -o "no-audio --loop" DP-1 "$WP_FILE" >/dev/null 2>&1
        notify-send -i "video-x-generic" "Живые обои активированы" "$(basename "$WP_FILE")"
    else
        # Статичные обои через hyprpaper
        killall mpvpaper 2>/dev/null
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
fi

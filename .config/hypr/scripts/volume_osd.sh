#!/usr/bin/env bash
# =============================================================================
# Volume OSD notification via Mako
# =============================================================================
VOL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -o '\[MUTED\]')

if [ -n "$MUTED" ]; then
    notify-send -h string:x-canonical-private-synchronous:vol_notif -h int:value:0 -i audio-volume-muted "Громкость" "Звук выключен 󰝟"
else
    ICON="audio-volume-high"
    [ "$VOL" -lt 60 ] && ICON="audio-volume-medium"
    [ "$VOL" -lt 30 ] && ICON="audio-volume-low"
    notify-send -h string:x-canonical-private-synchronous:vol_notif -h int:value:"$VOL" -i "$ICON" "Громкость: ${VOL}%"
fi

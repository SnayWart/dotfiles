#!/usr/bin/env bash
# =============================================================================
# Clipboard History Manager with Rofi + Cliphist
# =============================================================================
cliphist list | rofi -dmenu -theme ~/.config/rofi/autumn.rasi -p "  Буфер " | cliphist decode | wl-copy

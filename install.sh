#!/usr/bin/env bash
# =============================================================================
# SnayWart's Dotfiles Installer
# =============================================================================
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

echo "🌸 Installing SnayWart's Dotfiles..."
mkdir -p "$CONFIG_DIR"

for item in "$DOTFILES_DIR/.config"/*; do
    name="$(basename "$item")"
    target="$CONFIG_DIR/$name"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "📦 Backing up existing $name to $target.bak..."
        mv "$target" "$target.bak"
    fi
    echo "✨ Linking $name -> $target"
    ln -sfn "$item" "$target"
done

if [ -f "$DOTFILES_DIR/.bashrc" ]; then
    echo "📄 Updating ~/.bashrc..."
    [ -f "$HOME/.bashrc" ] && cp "$HOME/.bashrc" "$HOME/.bashrc.bak"
    cp "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
fi

echo "✅ Dotfiles installed successfully!"
echo "💡 Reload Hyprland with: hyprctl reload"

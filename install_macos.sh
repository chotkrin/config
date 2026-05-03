#!/usr/bin/env bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Deploying macOS Dotfiles..."

declare -a LINKS=(
    "aerospace/aerospace.toml:$HOME/.config/aerospace/aerospace.toml"
    "kitty/kitty.conf:$HOME/.config/kitty/kitty.conf"
    "zsh/.zshenv:$HOME/.zshenv"
    "zsh/.zshrc:$HOME/.config/zsh/.zshrc"
    "zsh/user.zsh:$HOME/.config/zsh/user.zsh"
    "yazi/init.lua:$HOME/.config/yazi/init.lua"
    "yazi/keymap.toml:$HOME/.config/yazi/keymap.toml"
    "ssh/config:$HOME/.ssh/config" 
    "scripts:$HOME/scripts"
)

for item in "${LINKS[@]}"; do
    src="${item%%:*}"
    dest="${item##*:}"
    
    full_src="$DOTFILES_DIR/$src"

    if [ ! -e "$full_src" ]; then
        echo "Skip: $full_src does not exist."
        continue
    fi

    mkdir -p "$(dirname "$dest")"

    ln -snf "$full_src" "$dest"
    
    echo "Linked: $dest -> $full_src"
done

echo "Constraining SSH privileges..."
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
if [ -f "$HOME/.ssh/config" ]; then
    chmod 600 "$HOME/.ssh/config"
fi

if [ -d "$HOME/scripts" ]; then
    chmod +x "$HOME/scripts/"* 2>/dev/null
fi

echo "macOS Dotfiles Deployment Succeeded"

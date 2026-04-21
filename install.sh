#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Deploying Dotfiles..."

declare -a LINKS=(
    "hypr/userprefs.conf:$HOME/.config/hypr/userprefs.conf"
    "yazi/init.lua:$HOME/.config/yazi/init.lua"
    "yazi/keymap.toml:$HOME/.config/yazi/keymap.toml"
    "zsh/user.zsh:$HOME/.config/zsh/user.zsh"
    "ssh/config:$HOME/.ssh/config" 
)

for item in "${LINKS[@]}"; do
    src="${item%%:*}"
    dest="${item##*:}"
    
    full_src="$DOTFILES_DIR/$src"

    mkdir -p "$(dirname "$dest")"

    ln -snf "$full_src" "$dest"
    
    echo "Linked: $dest -> $full_src"
done

echo "Constraint SSH priviliges..."
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
chmod 600 "$HOME/.ssh/config"

if [ -x "$DOTFILES_DIR/yazi/install.sh" ]; then
    echo "Install Yazi..."
    "$DOTFILES_DIR/yazi/install.sh"
fi

echo "Deploy Succeed"

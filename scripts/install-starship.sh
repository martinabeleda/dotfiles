#!/usr/bin/env bash
# Install Starship prompt (for systems without package manager support)

set -euo pipefail

if command -v starship &>/dev/null; then
    echo "Starship already installed: $(starship --version)"
else
    echo "Installing Starship..."
    tmp="$(mktemp)"
    trap 'rm -f "$tmp"' EXIT
    if ! curl -fsSL https://starship.rs/install.sh -o "$tmp"; then
        echo "Error: Failed to download Starship installer"
        exit 1
    fi
    if ! sh "$tmp" -y; then
        echo "Error: Starship installation failed"
        exit 1
    fi
    echo "Starship installed successfully"
fi

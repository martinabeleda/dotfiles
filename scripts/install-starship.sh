#!/usr/bin/env bash
# Install Starship prompt (for systems without package manager support)

set -e

if command -v starship &>/dev/null; then
    echo "Starship already installed: $(starship --version)"
else
    echo "Installing Starship..."
    if ! curl -sS https://starship.rs/install.sh -o /tmp/starship-install.sh; then
        echo "Error: Failed to download Starship installer"
        exit 1
    fi
    if ! sh /tmp/starship-install.sh -y; then
        echo "Error: Starship installation failed"
        exit 1
    fi
    rm -f /tmp/starship-install.sh
    echo "Starship installed successfully"
fi

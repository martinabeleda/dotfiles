#!/usr/bin/env bash
# Install Starship prompt (for systems without package manager support)

if command -v starship &>/dev/null; then
    echo "Starship already installed: $(starship --version)"
else
    echo "Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

#!/usr/bin/env bash
# Install Zoxide (for systems without package manager support)

if command -v zoxide &>/dev/null; then
    echo "Zoxide already installed: $(zoxide --version)"
else
    echo "Installing Zoxide..."
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi

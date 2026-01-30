#!/usr/bin/env bash
# Install Zoxide (for systems without package manager support)

set -e

if command -v zoxide &>/dev/null; then
    echo "Zoxide already installed: $(zoxide --version)"
else
    echo "Installing Zoxide..."
    if ! curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh -o /tmp/zoxide-install.sh; then
        echo "Error: Failed to download Zoxide installer"
        exit 1
    fi
    if ! bash /tmp/zoxide-install.sh; then
        echo "Error: Zoxide installation failed"
        exit 1
    fi
    rm -f /tmp/zoxide-install.sh
    echo "Zoxide installed successfully"
fi

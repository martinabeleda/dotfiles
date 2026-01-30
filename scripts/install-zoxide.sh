#!/usr/bin/env bash
# Install Zoxide (for systems without package manager support)

set -euo pipefail

if command -v zoxide &>/dev/null; then
    echo "Zoxide already installed: $(zoxide --version)"
else
    echo "Installing Zoxide..."
    tmp="$(mktemp)"
    trap 'rm -f "$tmp"' EXIT
    if ! curl -fsSL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh -o "$tmp"; then
        echo "Error: Failed to download Zoxide installer"
        exit 1
    fi
    if ! bash "$tmp"; then
        echo "Error: Zoxide installation failed"
        exit 1
    fi
    echo "Zoxide installed successfully"
fi

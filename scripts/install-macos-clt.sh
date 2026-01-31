#!/usr/bin/env bash

# Install macOS Command Line Tools (without Xcode)

set -euo pipefail

tmp_flag="/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress"
trap 'rm -f "$tmp_flag"' EXIT

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "Not macOS, skipping Command Line Tools installation"
    exit 0
fi

# Check if already installed
if xcode-select -p &>/dev/null; then
    echo "Command Line Tools already installed"
    exit 0
fi

echo "Installing macOS Command Line Tools..."
touch "$tmp_flag"

# Install only Command Line Tools, not all updates
PROD=$(softwareupdate -l | grep -o 'Command Line Tools for Xcode-[0-9.]*' | head -n 1)
if [ -n "$PROD" ]; then
    softwareupdate -i "$PROD" --verbose
else
    echo "Error: Could not find Command Line Tools package"
    exit 1
fi

echo "Command Line Tools installed successfully"

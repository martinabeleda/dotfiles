#!/usr/bin/env bash

# Install macOS Command Line Tools (without Xcode)

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
touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
softwareupdate -i -a
rm /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
echo "Command Line Tools installed successfully"

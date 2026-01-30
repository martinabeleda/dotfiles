#!/usr/bin/env bash
# Package installation abstraction for multiple platforms

set -euo pipefail

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPTS_DIR/detect-os.sh"

# Helper function to filter package lists (removes comments and empty lines)
filter_package_list() {
    local file="$1"
    grep -v '^#' "$file" | grep -v '^$' || true
}

install_packages() {
    local PACKAGES_DIR
    PACKAGES_DIR="$(dirname "$SCRIPTS_DIR")/packages"
    
    echo "Installing packages for $DOTFILES_OS..."
    
    case "$DOTFILES_OS" in
        macos)
            # Install Command Line Tools first (required for many dev tools)
            "$SCRIPTS_DIR/install-macos-clt.sh"
            
            if command -v brew &>/dev/null; then
                brew bundle --file="$PACKAGES_DIR/Brewfile"
            else
                echo "Error: Homebrew not installed. Install from https://brew.sh"
                return 1
            fi
            ;;
        debian)
            echo "Updating apt cache..."
            sudo apt update
            
            if [ -f "$PACKAGES_DIR/apt-packages.txt" ]; then
                # Filter out comments and empty lines, then install
                filter_package_list "$PACKAGES_DIR/apt-packages.txt" | xargs sudo apt install -y
            fi
            
            # Install tools not available in apt repos
            "$SCRIPTS_DIR/install-starship.sh"
            "$SCRIPTS_DIR/install-zoxide.sh"
            ;;
        arch)
            local pacman_file="$PACKAGES_DIR/pacman-packages.txt"
            if [ -f "$pacman_file" ] && [ -s "$pacman_file" ]; then
                # Use yay if available for AUR support, otherwise pacman
                if command -v yay &>/dev/null; then
                    filter_package_list "$pacman_file" | xargs yay -S --needed --noconfirm
                else
                    filter_package_list "$pacman_file" | xargs sudo pacman -S --needed --noconfirm
                fi
            fi
            ;;
        *)
            echo "Warning: Unknown OS '$DOTFILES_OS', skipping package installation"
            return 1
            ;;
    esac
    
    echo "Package installation complete!"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_packages
fi

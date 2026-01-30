#!/usr/bin/env bash
# Package installation abstraction for multiple platforms

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPTS_DIR/detect-os.sh"

install_packages() {
    local PACKAGES_DIR="$(dirname "$SCRIPTS_DIR")/packages"
    
    echo "Installing packages for $DOTFILES_OS..."
    
    case "$DOTFILES_OS" in
        macos)
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
                grep -v '^#' "$PACKAGES_DIR/apt-packages.txt" | grep -v '^$' | xargs sudo apt install -y
            fi
            
            # Install tools not available in apt repos
            "$SCRIPTS_DIR/install-starship.sh"
            "$SCRIPTS_DIR/install-zoxide.sh"
            ;;
        arch)
            if [ -f "$PACKAGES_DIR/pacman-packages.txt" ]; then
                # Use yay if available for AUR support, otherwise pacman
                if command -v yay &>/dev/null; then
                    grep -v '^#' "$PACKAGES_DIR/pacman-packages.txt" | grep -v '^$' | yay -S --needed --noconfirm -
                else
                    grep -v '^#' "$PACKAGES_DIR/pacman-packages.txt" | grep -v '^$' | sudo pacman -S --needed --noconfirm -
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

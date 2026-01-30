#!/usr/bin/env bash
# OS and distribution detection for dotfiles
# Source this file to set DOTFILES_OS and DOTFILES_HOSTNAME

detect_os() {
    case "$(uname -s)" in
        Darwin)
            echo "macos"
            ;;
        Linux)
            if [ -f /etc/os-release ]; then
                . /etc/os-release
                case "$ID" in
                    debian|raspbian|ubuntu)
                        echo "debian"
                        ;;
                    arch|manjaro)
                        echo "arch"
                        ;;
                    *)
                        echo "linux-unknown"
                        ;;
                esac
            else
                echo "linux-unknown"
            fi
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

detect_hostname() {
    hostname -s 2>/dev/null || cat /etc/hostname 2>/dev/null || echo "unknown"
}

# Export for use by other scripts
export DOTFILES_OS=$(detect_os)
export DOTFILES_HOSTNAME=$(detect_hostname)

# Platform-specific shell initialization

case "$(uname -s)" in
    Darwin)
        # macOS: Homebrew (Apple Silicon or Intel)
        if [ -f /opt/homebrew/bin/brew ]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [ -f /usr/local/bin/brew ]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
        ;;
    Linux)
        # Linuxbrew (optional, if installed)
        if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        fi
        ;;
esac

# Linux Support Plan

This document outlines the plan to extend dotfiles support from macOS-only to include Linux distributions.

## Current State Analysis

### Repository Structure
```
dotfiles/
├── install              # Dotbot bootstrap script (bash)
├── install.conf.yaml    # Dotbot configuration
├── brew/Brewfile        # macOS package definitions
├── zsh/.zshrc           # Shell config (macOS-specific paths)
├── zsh/.zprofile        # Homebrew initialization (macOS-only)
├── nvim/                # Neovim config (cross-platform)
├── tmux/.tmux.conf      # Tmux config (cross-platform)
├── starship.toml        # Prompt config (cross-platform)
├── .gitconfig           # Git config (cross-platform)
└── .github/workflows/   # CI (already runs on Ubuntu!)
```

### macOS-Specific Items
1. **brew/Brewfile** - Homebrew packages only
2. **zsh/.zprofile** - Hardcoded `/opt/homebrew/bin/brew shellenv`
3. **zsh/.zshrc** - Contains `/opt/homebrew/` paths
4. **README.md** - macOS-centric setup instructions

### Cross-Platform Items (no changes needed)
- `nvim/` - Neovim config
- `tmux/.tmux.conf` - Tmux config
- `starship.toml` - Starship prompt
- `.gitconfig` - Git config
- `install.conf.yaml` - Dotbot links (mostly)

---

## Target Systems

| System | OS | Package Manager | Architecture | Hostname |
|--------|-----|-----------------|--------------|----------|
| MacBook | macOS | Homebrew | arm64/x86_64 | - |
| Raspberry Pi | Debian ARM | apt | aarch64 | beehive |
| Desktop | Arch Linux | pacman/yay | x86_64 | omarchy |

---

## Implementation Plan

### Phase 1: OS/Distro Detection

Create `scripts/detect-os.sh`:

```bash
#!/usr/bin/env bash

detect_os() {
    case "$(uname -s)" in
        Darwin) echo "macos" ;;
        Linux)
            if [ -f /etc/os-release ]; then
                . /etc/os-release
                case "$ID" in
                    debian|raspbian|ubuntu) echo "debian" ;;
                    arch|manjaro) echo "arch" ;;
                    *) echo "linux-unknown" ;;
                esac
            else
                echo "linux-unknown"
            fi
            ;;
        *) echo "unknown" ;;
    esac
}

detect_hostname() {
    hostname -s 2>/dev/null || cat /etc/hostname 2>/dev/null
}

# Export for use by other scripts
export DOTFILES_OS=$(detect_os)
export DOTFILES_HOSTNAME=$(detect_hostname)
```

### Phase 2: Package Manager Abstraction

Create `scripts/packages.sh`:

```bash
#!/usr/bin/env bash

source "$(dirname "$0")/detect-os.sh"

install_packages() {
    case "$DOTFILES_OS" in
        macos)
            brew bundle --file=packages/Brewfile
            ;;
        debian)
            sudo apt update
            xargs -a packages/apt-packages.txt sudo apt install -y
            ;;
        arch)
            # Use yay for AUR support
            if command -v yay &>/dev/null; then
                yay -S --needed --noconfirm - < packages/pacman-packages.txt
            else
                sudo pacman -S --needed --noconfirm - < packages/pacman-packages.txt
            fi
            ;;
    esac
}
```

### Phase 3: Package Mapping

Create `packages/` directory with platform-specific package lists:

#### packages/Brewfile (existing, move from brew/)
Keep existing Brewfile for macOS.

#### packages/apt-packages.txt (Debian/Raspberry Pi)
```
# Core tools
zsh
git
curl
wget
htop
tmux
neovim
ripgrep
bat
jq
tree
fzf

# Development
build-essential
python3
python3-pip
python3-venv
nodejs
npm

# Optional (comment out if not needed)
# ffmpeg
# docker.io
```

#### packages/pacman-packages.txt (Arch)
```
# Core tools
zsh
git
curl
wget
htop
tmux
neovim
ripgrep
bat
jq
tree
fzf
zoxide
starship

# Development
base-devel
python
python-pip
nodejs
npm
rustup

# AUR packages (requires yay)
# pyenv
# pyenv-virtualenv
```

#### Package Mapping Table

| Brewfile | apt (Debian) | pacman (Arch) | Notes |
|----------|--------------|---------------|-------|
| `brew "neovim"` | `neovim` | `neovim` | ✅ Same name |
| `brew "ripgrep"` | `ripgrep` | `ripgrep` | ✅ Same name |
| `brew "bat"` | `bat` | `bat` | ✅ Same name |
| `brew "htop"` | `htop` | `htop` | ✅ Same name |
| `brew "tmux"` | `tmux` | `tmux` | ✅ Same name |
| `brew "jq"` | `jq` | `jq` | ✅ Same name |
| `brew "tree"` | `tree` | `tree` | ✅ Same name |
| `brew "starship"` | (install script) | `starship` | Debian: curl install |
| `brew "zoxide"` | (install script) | `zoxide` | Debian: curl install |
| `brew "pyenv"` | (git clone) | `pyenv` (AUR) | Manual install |
| `brew "node"` | `nodejs` | `nodejs` | Different name |
| `brew "gh"` | `gh` | `github-cli` | Different name |
| `brew "postgresql@14"` | `postgresql` | `postgresql` | Version handling |
| `brew "ffmpeg"` | `ffmpeg` | `ffmpeg` | ✅ Same name |
| Homebrew taps | N/A | AUR | Platform-specific |

### Phase 4: Shell Configuration Updates

#### zsh/.zprofile → Platform-aware

```bash
# Platform-specific shell initialization

case "$(uname -s)" in
    Darwin)
        # macOS: Homebrew
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
```

#### zsh/.zshrc → Platform-aware paths

```bash
# Universal paths
export PATH=$HOME/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH

# macOS-specific paths
if [[ "$(uname -s)" == "Darwin" ]]; then
    export PATH=/opt/homebrew/bin:$PATH
    export PATH=/opt/homebrew/opt/libpq/bin:$PATH
    export PATH=/opt/homebrew/opt/openjdk@17/bin:$PATH
    export CPPFLAGS="-I/opt/homebrew/opt/openjdk@17/include"
fi

# ... rest of config (cross-platform)
```

### Phase 5: Install Script Modifications

Modify main `install` script to be platform-aware:

```bash
#!/usr/bin/env bash
set -e

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source detection
source "$BASEDIR/scripts/detect-os.sh"

echo "Detected OS: $DOTFILES_OS"
echo "Hostname: $DOTFILES_HOSTNAME"

# Run dotbot for symlinks
CONFIG="install.conf.yaml"
DOTBOT_DIR="dotbot"
DOTBOT_BIN="bin/dotbot"

cd "${BASEDIR}"
git -C "${DOTBOT_DIR}" submodule sync --quiet --recursive
git submodule update --init --recursive "${DOTBOT_DIR}"

"${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" -c "${CONFIG}" "${@}"

# Optional: Install packages
if [[ "$1" == "--packages" ]] || [[ "$1" == "-p" ]]; then
    source "$BASEDIR/scripts/packages.sh"
    install_packages
fi
```

### Phase 6: Platform-Specific Dotbot Configs (Optional)

For significantly different setups, consider separate configs:

```
install.conf.yaml          # Common links
install.macos.yaml         # macOS-specific
install.linux.yaml         # Linux-specific
install.debian.yaml        # Debian-specific
install.arch.yaml          # Arch-specific
```

Or use conditional linking in a single file with shell commands.

### Phase 7: Starship Installation Script

Create `scripts/install-starship.sh` for Debian:

```bash
#!/usr/bin/env bash

if ! command -v starship &>/dev/null; then
    echo "Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi
```

### Phase 8: Zoxide Installation Script

Create `scripts/install-zoxide.sh` for Debian:

```bash
#!/usr/bin/env bash

if ! command -v zoxide &>/dev/null; then
    echo "Installing Zoxide..."
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi
```

---

## File Structure (After Implementation)

```
dotfiles/
├── install                     # Main bootstrap (updated)
├── install.conf.yaml           # Dotbot config (keep universal)
├── scripts/
│   ├── detect-os.sh            # OS/distro detection
│   ├── packages.sh             # Package installation abstraction
│   ├── install-starship.sh     # Starship installer (for apt systems)
│   └── install-zoxide.sh       # Zoxide installer (for apt systems)
├── packages/
│   ├── Brewfile                # macOS packages (moved from brew/)
│   ├── apt-packages.txt        # Debian packages
│   └── pacman-packages.txt     # Arch packages
├── zsh/
│   ├── .zshrc                  # Updated with platform detection
│   └── .zprofile               # Updated with platform detection
├── nvim/                       # (unchanged)
├── tmux/                       # (unchanged)
├── starship.toml               # (unchanged)
├── .gitconfig                  # (unchanged)
└── docs/
    └── LINUX_SUPPORT_PLAN.md   # This document
```

---

## Migration Steps

1. Create `scripts/` directory with detection scripts
2. Create `packages/` directory, move Brewfile, add apt/pacman lists
3. Update `zsh/.zprofile` with platform detection
4. Update `zsh/.zshrc` to use conditional paths
5. Update main `install` script with platform awareness
6. Update `README.md` with multi-platform instructions
7. Update GitHub Actions to test on multiple platforms

---

## Testing Approach

### Local Testing
1. **macOS**: Run on existing Mac to ensure no regressions
2. **Raspberry Pi**: SSH to beehive.local, clone repo, run install
3. **Arch**: Test on omarchy when set up

### CI Updates (.github/workflows/build.yaml)

```yaml
name: CI
on: [push, pull_request]
jobs:
  test-ubuntu:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install dependencies
        run: sudo apt-get install -y zsh
      - name: Run install
        run: |
          export RUNZSH=no CHSH=no
          HOME=$(mktemp -d) ./install

  test-macos:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run install
        run: |
          export RUNZSH=no CHSH=no
          HOME=$(mktemp -d) ./install
```

### Manual Verification Checklist
- [ ] Symlinks created correctly
- [ ] Oh My Zsh installs
- [ ] Zsh plugins install
- [ ] Starship prompt works
- [ ] Neovim config loads
- [ ] Tmux config loads
- [ ] TPM installs

---

## Hostname-Specific Configurations (Future Enhancement)

For machine-specific settings (e.g., omarchy-only configs):

```bash
# In .zshrc
case "$(hostname -s)" in
    omarchy)
        # Arch desktop specific
        export DISPLAY=:0
        alias monitors="xrandr --auto"
        ;;
    beehive)
        # Raspberry Pi specific
        alias temp="vcgencmd measure_temp"
        ;;
esac
```

Or use separate files:
```
zsh/
├── .zshrc              # Common config
├── .zshrc.macos        # macOS-specific (sourced if exists)
├── .zshrc.debian       # Debian-specific
├── .zshrc.arch         # Arch-specific
└── .zshrc.omarchy      # Host-specific overrides
```

---

## Implementation Priority

1. **High**: OS detection + platform-aware shell configs
2. **High**: Package manager abstraction  
3. **Medium**: Package lists for apt/pacman
4. **Medium**: CI updates for multi-platform testing
5. **Low**: Hostname-specific configurations
6. **Low**: Separate dotbot configs per platform

---

## Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| Package name differences | Maintain mapping table, test on each platform |
| Missing packages on apt | Use install scripts for starship, zoxide, etc. |
| Breaking existing macOS setup | Test on Mac before merging |
| Oh My Zsh differences | Should work identically (it's a git clone) |
| Path differences | Conditional exports based on `uname` |

---

## Open Questions

1. Should we use Linuxbrew on Linux? (Probably not - native package managers preferred)
2. Include AUR helper (yay) setup in Arch packages script?
3. Separate install scripts per platform, or one unified script with flags?
4. How to handle Neovim plugin installation (packer) across platforms?

---

## Next Steps

1. Review this plan
2. Implement Phase 1 (detection scripts)
3. Test detection on all three target systems
4. Implement remaining phases incrementally
5. Update README with multi-platform docs

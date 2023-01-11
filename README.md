# dotfiles

A collection of my configuration and dotfiles for easy setup

## :construction: setup

Install the repo locally:

```shell
git clone https://github.com/martinabeleda/dotfiles.git
cd dotfiles
```

Install mac developer tools **without** installing XCode:

```shell
touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
softwareupdate -i -a
rm /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
```

## :beers: brew

Install homebrew:

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

We use brew bundle to manage homebrew dependencies in a reproducible way:

```shell
brew bundle --file=Brewfile
```

## :hammer: zsh

At this point, `zsh` should have been installed from the `Brewfile`. Verify this:

```shell
zsh --version
```

I'm using [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) to manage `zsh`. Install using the [basic installation](https://github.com/ohmyzsh/ohmyzsh#basic-installation):

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
Link `.zshrc` to `$HOME`:

```shell
ln -s ~/Development/martinabeleda/dotfiles/.zshrc ~/.zshrc
```

Change shell to zsh:

```shell
chsh -s /usr/local/bin/zsh
```

## :wrench: nvim

Most of my neovim setup has been sourced from [josean](https://www.youtube.com/watch?v=vdn_pKJUda8)

```shell
ln -s ~/Development/martinabeleda/dotfiles/nvim ~/.config/nvim
```

### :robot: copilot

Copilot requires Node.js as a pre-requisite. I've installed this [here](https://nodejs.org/en/download)

After that, you can run the setup from neovim:

```
:Copilot setup
```

After that you can find help by:

```
:help copilot
```

### Links

- [Rust nvim guide](https://rsdlt.github.io/posts/rust-nvim-ide-guide-walkthrough-development-debug/)

## :rocket: starship prompt

See the [starship docs](https://starship.rs/guide/#%F0%9F%9A%80-installation) for installation instructions. Starship should already be set up by virtue of installing our brew dependencies and symlinking the `.zshrc` file.

```shell
ln -s ~/Development/martinabeleda/dotfiles/starship.toml ~/.config/starship.toml
```

## :package: tmux

Install the tmux plugin manager:

```shell
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Symlink tmux config to `~/.config`

```shell
ln -s ~/Development/martinabeleda/dotfiles/.tmux.conf ~/.tmux.conf
```

### Installing plugins

1. Add new plugin to `.tmux.conf` with `set -g @plugin '...'`
1. Press `prefix` + `I` to fetch the plugin.

## Git aliases

Create symlink to home directory:

```shell
ln -s ~/Development/martinabeleda/dotfiles/git.sh ~/git.sh
```

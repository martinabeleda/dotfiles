# dotfiles

![main workflow](https://github.com/martinabeleda/dotfiles/actions/workflows/build.yaml/badge.svg)

A collection of my configuration and dotfiles for easy setup

## :construction: setup

Install the repo locally:

```shell
git clone https://github.com/martinabeleda/dotfiles.git
cd dotfiles
```

### :beers: brew

Install homebrew:

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

We use brew bundle to manage homebrew dependencies in a reproducible way. To install all dependencies:

```shell
brew bundle --file=brew/Brewfile
```

To dump a `Brewfile` of current entries:

```shell
rm brew/Brewfile && brew bundle dump --file=brew/Brewfile
```

See more `brew bundle` tips [here](https://gist.github.com/ChristopherA/a579274536aab36ea9966f301ff14f3f)

### :robot: dotbot

Link all dotfiles and install plugins:

```shell
./install
```

This is managed by [dotbot](https://github.com/anishathalye/dotbot)

### :hammer: zsh

Change shell to zsh:

```shell
zsh
```

## :wrench: nvim

Most of my neovim setup has been sourced from [josean](https://www.youtube.com/watch?v=vdn_pKJUda8)

### :postbox: packer

Packer manages neovim plugins. To set everything up, run packer sync:

```shell
:PackerSync
```

### Links

- [Rust nvim guide](https://rsdlt.github.io/posts/rust-nvim-ide-guide-walkthrough-development-debug/)

## :rocket: starship prompt

See the [starship docs](https://starship.rs/guide/#%F0%9F%9A%80-installation) for installation instructions. Starship should already be set up by virtue of installing our brew dependencies and symlinking the `.zshrc` file.

## :package: tmux

### Installing plugins

1. Add new plugin to `.tmux.conf` with `set -g @plugin '...'`
1. Press `prefix` + `I` to fetch the plugin.

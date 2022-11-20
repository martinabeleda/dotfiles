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

## :rocket: starship prompt

See the [starship docs](https://starship.rs/guide/#%F0%9F%9A%80-installation) for installation instructions. Starship should already be set up by virtue of installing our brew dependencies and symlinking the `.zshrc` file.

```shell
ln -s ~/Development/martinabeleda/dotfiles/starship.toml ~/.config/starship.toml
```

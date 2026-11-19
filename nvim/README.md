# Neovim

[LazyVim](https://www.lazyvim.org/) on [lazy.nvim](https://lazy.folke.io/), set up to match what
[Omarchy](https://omarchy.org) ships out of the box (its `omarchy-nvim` package: the LazyVim starter
plus a small overlay), with a few personal overrides.

The leader key is **space**. Press it and wait for which-key to list everything, or see the
[LazyVim keymaps](https://www.lazyvim.org/keymaps).

## Layout

| Path | What |
|---|---|
| `init.lua`, `lua/config/lazy.lua` | LazyVim starter bootstrap (unchanged) |
| `lua/config/options.lua` | Omarchy defaults + personal overrides |
| `lua/config/{keymaps,autocmds}.lua` | Starter placeholders for extra keymaps/autocmds |
| `lazyvim.json` | Enabled LazyVim extras (edit with `:LazyExtras`) |
| `lazy-lock.json` | Pinned plugin versions (commit after `:Lazy update`) |
| `lua/plugins/theme.lua` | Rose Pine, transparent |
| `lua/plugins/*.lua` | Omarchy overlay: no news popups, no smooth scroll, transparent lualine |
| `plugin/after/transparency.lua` | Omarchy's transparent-background highlight overrides |

## Compared with Omarchy

Same as Omarchy: neo-tree explorer (`<leader>e`), format on save off (`<leader>uf` toggles it),
smooth scrolling off, LazyVim news popups off, transparent background and status line.

Different:

- **Options**: 4-space indent, relative line numbers, `-` counts as part of a word.
- **Language extras**: python (ty + ruff), typescript, rust, clangd, terraform, docker, yaml, toml, json.
- **Theme**: pinned to Rose Pine. Omarchy symlinks `theme.lua` to its current system theme and
  hot-reloads it; that machinery (`all-themes.lua`, `omarchy-theme-hotreload.lua`) is left out.
- **Clipboard**: Omarchy's Wayland/tmux `remote_clipboard.lua` is left out; LazyVim's default
  (system clipboard, OSC 52 over SSH) is used.

## Useful commands

| Command | Description |
|---|---|
| `:Lazy` | Plugin manager UI (`:Lazy sync` to install/update/clean) |
| `:LazyExtras` | Enable/disable LazyVim extras (writes `lazyvim.json`) |
| `:Mason` | Manage LSP servers, formatters and linters |
| `:LazyHealth` | Health check for LazyVim and its plugins |

External tools LazyVim expects: `git`, `rg`, `fd`, `lazygit` (`<leader>gg`), a C compiler and
`tree-sitter` for parsers, and `node` for some language servers.

# Neovim Configuration Guide

## Leader Key

The leader key is set to **space** (`<leader>`) for all mapped commands.

---

## File Navigation & Search

| Keybinding | Command | Description |
|------------|---------|-------------|
| `<leader>ff` | `Telescope find_files` | Find files in current directory (respects `.gitignore`) |
| `<leader>fb` | `Telescope buffers` | List open buffers |
| `<leader>fs` | `Telescope live_grep` | Live grep search (uses **ripgrep** for speed) |
| `<leader>fc` | `Telescope grep_string` | Find string under cursor |
| `<leader>fh` | `Telescope help_tags` | List available help tags |
| `<leader>sv` | `<C-w>v` | Split window vertically |
| `<leader>sh` | `<C-w>s` | Split window horizontally |
| `<leader>se` | `<C-w>=` | Make split windows equal |
| `<leader>sx` | `:close` | Close current split window |
| `<leader>to` | `:tabnew` | Open new tab |
| `<leader>tx` | `:tabclose` | Close current tab |
| `<leader>tn` | `:tabn` | Go to next tab |
| `<leader>tp` | `:tabp` | Go to previous tab |
| `<leader>e` | `:NvimTreeToggle` | Toggle file explorer |

---

## LSP & Code Editing (Language Servers)

| Keybinding | Command | Description |
|------------|---------|-------------|
| `gf` | `Lspsaga lsp_finder` | Show definition and references |
| `gD` | `vim.lsp.buf.declaration()` | Go to declaration |
| `gd` | `Lspsaga peek_definition` | See definition in window |
| `gi` | `vim.lsp.buf.implementation()` | Go to implementation |
| `K` | `Lspsaga hover_doc` | Show documentation under cursor |
| `[d` | `Lspsaga diagnostic_jump_prev` | Jump to previous diagnostic |
| `]d` | `Lspsaga diagnostic_jump_next` | Jump to next diagnostic |
| `<leader>d` | `Lspsaga show_line_diagnostics` | Show line diagnostics |
| `<leader>D` | `Lspsaga show_cursor_diagnostics` | Show cursor diagnostics |
| `<leader>ca` | `Lspsaga code_action` | Show available code actions |
| `<leader>rn` | `Lspsaga rename` | Smart rename |
| `<leader>rf` | `vim.lsp.buf.rename()` | Rename symbol (TypeScript) |
| `<leader>a` | `vim.lsp.buf.code_action` | Code action (Rust) |
| `<leader>o` | `LSoutlineToggle` | Show outline on right |

---

## Git Operations

| Keybinding | Command | Description |
|------------|---------|-------------|
| `<leader>u` | `UndotreeToggle` | Toggle undo tree |
| `x` | `"_x` | Delete without copying |
| `jk` | `<ESC>` | Exit insert mode |

---



## Useful Commands

### Package Management

| Command | Description |
|---------|-------------|
| `:PackerSync` | Update/install all plugins |
| `:Mason` | Open Mason UI to manage LSP servers, linters, formatters |
| `:MasonInstall <server>` | Install a specific LSP server (e.g., `:MasonInstall lua_ls`) |
| `:MasonInstall <formatter>` | Install a formatter (e.g., `:MasonInstall stylua`) |
| `:MasonUninstall <server>` | Uninstall a server |

### Window Management

| Command | Description |
|---------|-------------|
| `:MaximizerToggle` | Toggle split window maximization |
| `:NvimTreeToggle` | Toggle file explorer |
| `:UndotreeToggle` | Toggle undo tree |

### Navigation & Search

| Command | Description |
|---------|-------------|
| `:nohl` | Clear search highlight |
| `:Telescope find_files` | Find files |
| `:Telescope live_grep` | Live grep search |
| `:Telescope buffers` | List buffers |
| `:Telescope help_tags` | List help tags |

### LSP Commands

| Command | Description |
|---------|-------------|
| `:lua vim.lsp.buf.declaration()` | Go to declaration |
| `:lua vim.lsp.buf.definition()` | Go to definition |
| `:lua vim.lsp.buf.rename()` | Rename symbol |
| `:lua vim.lsp.buf.code_action()` | Code action |
| `:lua vim.lsp.buf.format()` | Format buffer |

### Fugitive (Git)

| Command | Description |
|---------|-------------|
| `:G` | Show git status |
| `:Gcommit` | Commit changes |
| `:Gdiff` | Show git diff |
| `:Gblame` | Show blame |

---

## Default Keybindings

| Key | Action |
|-----|--------|
| `x` | Delete without copying |
| `jk` | Exit insert mode |
| `<leader>nh` | Clear search highlight (`:nohl`) |
| `<leader>+` | Increment number (`<C-a>`) |
| `<leader>-` | Decrement number (`<C-x>`) |

---

## Plugins Overview

| Plugin | Purpose |
|--------|---------|
| **telescope.nvim** | Fuzzy finder for files, buffers, and grep |
| **nvim-tree** | File explorer |
| **mason.nvim** | LSP server & formatter installer |
| **lspsaga.nvim** | Enhanced LSP UI |
| **Comment.nvim** | Multi-line commenting |
| **nvim-cmp** | Autocompletion |
| **gitsigns.nvim** | Git diff visualization |
| **undotree** | Undo tree navigation |
| **vim-fugitive** | Git integration |
| **vim-maximizer** | Window maximization |
| **nvim-autopairs** | Auto-close parentheses/brackets |
| **nvim-treesitter** | Syntax trees for better parsing |

---

## Configuration Tips

1. **Change leader key**: Modify `vim.g.mapleader` in `core/keymaps.lua`
2. **Install LSP servers**: Use `:MasonInstall <server_name>`
3. **Update plugins**: `:PackerSync`
4. **Format code**: `:lua vim.lsp.buf.format()` or `<leader>ca`
5. **Search faster**: Telescope uses ripgrep (`rg`) by default

---

*Last updated: 2026-03-21*

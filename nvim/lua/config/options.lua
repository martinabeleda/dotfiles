-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Omarchy defaults
vim.g.autoformat = false

-- Personal overrides of the Omarchy defaults
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.iskeyword:append("-") -- treat `-` as part of a word

-- Python (lang.python extra): ty for types/hover, ruff for lint/format
vim.g.lazyvim_python_lsp = "ty"
vim.g.lazyvim_python_ruff = "ruff"

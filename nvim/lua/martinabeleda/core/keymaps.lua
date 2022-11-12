-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap 

---------------------
-- General Keymaps
---------------------

keymap.set("i", "jk", "<ESC>") -- use jk to exit insert mode  

keymap.set("n", "<leader>nh", ":nohl<CR>") -- clear search highlight

keymap.set("n", "x", '"_x') -- delete single character without copy

keymap.set("n", "<leader>+", "<C-a>") -- increment number
keymap.set("n", "<leader>-", "<C-x>") -- decrement number

keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically 
keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally 
keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width
keymap.set("n", "<leader>sx", ":close<CR>") -- close current split window

keymap.set("n", "<leader>to", ":tabnew<CR>") -- open new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab
keymap.set("n", "<leader>tn", ":tabn<CR>") --  go to next tab
keymap.set("n", "<leader>tp", ":tabp<CR>") --  go to previous tab


----------------------
-- Plugin Keybinds
----------------------

keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>") -- toggle split window maximization



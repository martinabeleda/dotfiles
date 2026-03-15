-- import lspconfig plugin safely
local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
	return
end

-- import cmp-nvim-lsp plugin safely
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	return
end

-- import rust tools plugin safely
local rt_setup, rust_tools = pcall(require, "rust-tools")
if not rt_setup then
	return
end

local keymap = vim.keymap -- for conciseness
local python_format_augroup = vim.api.nvim_create_augroup("LspPythonFormatting", {})

-- enable keybinds only for when lsp server available
local on_attach = function(client, bufnr)
	-- keybind options
	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- set keybinds
	keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts) -- show definition, references
	keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- got to declaration
	keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits in window
	keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
	keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts) -- see available code actions
	keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
	keymap.set("n", "<leader>d", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show diagnostics for line
	keymap.set("n", "<leader>D", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
	keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
	keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
	keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
	keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts) -- see outline on right hand side

	-- typescript specific keymaps (e.g. rename file and update imports)
	if client.name == "ts_ls" then
		keymap.set("n", "<leader>rf", ":lua vim.lsp.buf.rename()<CR>", opts) -- rename symbol
	end

	-- Prefer ty for Python language intelligence.
	if client.name == "ruff" then
		client.server_capabilities.hoverProvider = false
		vim.api.nvim_clear_autocmds({ group = python_format_augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = python_format_augroup,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({
					filter = function(format_client)
						return format_client.name == "ruff"
					end,
					bufnr = bufnr,
				})
			end,
		})
	end
end

-- used to enable autocompletion (assign to every lsp server config)
local capabilities = cmp_nvim_lsp.default_capabilities()

-- configure typescript server
lspconfig["ts_ls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure rust tools
rust_tools.setup({
	server = {
		on_attach = function(_, bufnr)
			-- Hover actions
			vim.keymap.set("n", "<C-space>", rust_tools.hover_actions.hover_actions, { buffer = bufnr })
			-- Code action groups
			vim.keymap.set("n", "<Leader>a", rust_tools.code_action_group.code_action_group, { buffer = bufnr })
		end,
	},
	inlay_hints = {
		only_current_line = true,
		show_parameter_hints = true,
		parameter_hints_prefix = "<- ",
		other_hints_prefix = "=> ",
	},
})

lspconfig["rust_analyzer"].setup({
	settings = {
		["rust-analyzer"] = {
			cargo = {
				allFeatures = true,
			},
		},
	},
})

-- configure python servers
lspconfig["ruff"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

lspconfig["ty"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- import mason plugin safely
local mason_status, mason = pcall(require, "mason")
if not mason_status then
	return
end

-- import mason-lspconfig plugin safely
local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status then
	return
end

-- import mason-null-ls plugin safely
local mason_null_ls_status, mason_null_ls = pcall(require, "mason-null-ls")
if not mason_null_ls_status then
	return
end

mason.setup()

mason_lspconfig.setup({
	-- list of servers for mason to install
	ensure_installed = {
		"tsserver",
		"lua_ls",
		"pyright",
		"rust_analyzer",
		"clangd",
	},
})

mason_null_ls.setup({
	-- list of formatters & linters for mason to install
	ensure_installed = {
		"rustfmt",
		"prettier", -- ts/js formatter
		"stylua", -- lua formatter
		"black", -- python formatter
		"pylint", -- python linter
		"clang-format", -- c/c++ formatter
	},
	-- auto-install configured formatters & linters (with null-ls)
	automatic_installation = true,
})

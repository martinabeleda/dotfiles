-- https://github.com/scalameta/nvim-metals/discussions/39
local api = vim.api
local cmd = vim.cmd
local map = vim.keymap.set

-- Import nvim-metals plugin safely
local metals_status, metals = pcall(require, "metals")
if not metals_status then
	return
end

-- Import cmp-nvim-lsp plugin safely
local cmp_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_lsp_status then
	return
end

local metals_config = metals.bare_config()

-- Example of settings
metals_config.settings = {
	showImplicitArguments = true,
	excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
}

-- Status bar provider
metals_config.init_options.statusBarProvider = "on"

-- Set capabilities for nvim-cmp
metals_config.capabilities = cmp_nvim_lsp.default_capabilities()

metals_config.on_attach = function(client, bufnr)
	metals.setup_dap()
end

-- Autocmd to start Metals
local nvim_metals_group = api.nvim_create_augroup("nvim-metals", { clear = true })
api.nvim_create_autocmd("FileType", {
	pattern = { "scala", "sbt", "java" },
	callback = function()
		metals.initialize_or_attach(metals_config)
	end,
	group = nvim_metals_group,
})

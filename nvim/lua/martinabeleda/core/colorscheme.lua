local colorscheme_status, _ = pcall(vim.cmd, "colorscheme tokyonight-moon")
if not colorscheme_status then
	print("Colorscheme not found!")
	return
end

local highlight_status, _ = pcall(vim.cmd, "highlight Normal guibg=none")
if not highlight_status then
	print("Unable to make background transparent")
	return
end

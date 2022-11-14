local status, _ = pcall(vim.cmd, "colorscheme github_dark")
if not status then
  print("Colorscheme not found!")
  return
end

-- Omarchy symlinks this file to its current system theme. There is no Omarchy
-- theme on macOS, so pin Rose Pine (dark "main" variant) with transparency.
return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    opts = {
      styles = {
        transparency = true,
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "rose-pine",
    },
  },
}

-- ---------------------------------------- colorscheme ------------------------------------------------------

local M = {}

M.load = function()
  require("catppuccin").setup({
    flavour = "mocha",
    compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
    transparent_background = true,
    color_overrides = {
      all = {
        rosewater = "#dc8a78",
        flamingo = "#DD7878",
        pink = "#ea76cb",
        mauve = "#8839EF",
        red = "#D20F39",
        maroon = "#E64553",
        peach = "#FE640B",
        yellow = "#df8e1d",
        green = "#40A02B",
        teal = "#179299",
        sky = "#04A5E5",
        sapphire = "#209FB5",
        blue = "#1e66f5",
        lavender = "#7287FD",

        text = "#abb2bf",
      },
    },
    integrations = {
      cmp = true,
      gitsigns = true,
      gitgutter = true,
      nvimtree = true,
      treesitter = true,
      markdown = true,
    },
  })
  vim.wo.cursorline = true
  vim.cmd.colorscheme("catppuccin")
end

return M

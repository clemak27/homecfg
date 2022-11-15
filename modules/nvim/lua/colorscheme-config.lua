-- ---------------------------------------- colorscheme ------------------------------------------------------

local M = {}

M.load = function()
  require("catppuccin").setup({
    flavour = "mocha",
    compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
    transparent_background = true,
    color_overrides = {
      all = {
        mauve = "#c678dd",
        red = "#e06c75",
        peach = "#d19a66",
        yellow = "#e5c07b",
        green = "#98c379",
        sky = "#56b6c2",
        blue = "#61afef",

        text = "#abb2bf",
      },
    },
    custom_highlights = function(colors)
      return {
        NvimTreeVertSplit = { link = "VertSplit" },
        ["@field"] = { fg = colors.red },
      }
    end,
    integrations = {
      cmp = true,
      fidget = true,
      gitgutter = true,
      gitsigns = true,
      lsp_saga = true,
      markdown = true,
      mason = true,
      nvimtree = true,
      treesitter = true,
    },
  })

  require("transparent").setup({
    enable = true,
    extra_groups = {
      -- nvim-bufferline
      "BufferLineTabClose",
      "BufferlineBufferSelected",
      "BufferLineFill",
      "BufferLineBackground",
      "BufferLineSeparator",
      "BufferLineIndicatorSelected",
    },
    exclude = {},
  })

  vim.wo.fillchars = "eob: "
  vim.wo.cursorline = true
  vim.cmd.colorscheme("catppuccin")
end

return M

-- ---------------------------------------- catppuccin ------------------------------------------------------

local M = {}

M.load = function()
  require("catppuccin").setup({
    flavour = "mocha",
    compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
    -- transparent_background = true,
    color_overrides = {},
    custom_highlights = function(colors)
      return {
        NvimTreeVertSplit = { link = "VertSplit" },
        ["@field"] = { fg = colors.red },
      }
    end,
    no_italic = true,
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
    extra_groups = {},
    exclude = {},
  })

  vim.wo.fillchars = "eob: "
  vim.wo.cursorline = true
  vim.cmd.colorscheme("catppuccin")
end

return M

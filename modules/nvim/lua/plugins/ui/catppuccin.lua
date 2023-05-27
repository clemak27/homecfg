return {
  {
    "catppuccin/nvim",
    as = "catppuccin",
    priority = 1000,
    config = function()
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
          lsp_trouble = true,
          markdown = true,
          mason = true,
          navic = {
            enabled = true,
            custom_bg = "#181825",
          },
          noice = true,
          notify = true,
          nvimtree = true,
          treesitter = true,
        },
      })

      vim.wo.fillchars = "eob: "
      vim.wo.cursorline = true
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}

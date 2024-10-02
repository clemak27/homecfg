return {
  {
    "catppuccin/nvim",
    as = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
        transparent_background = os.getenv("NVIM_TRANSPARENT") == "true",
        color_overrides = {},
        custom_highlights = function(colors)
          return {
            NvimTreeVertSplit = { link = "VertSplit" },
            ["@field"] = { fg = colors.red },
            ["@comment.todo.comment"] = { fg = colors.yellow, bg = nil },
          }
        end,
        no_italic = false,
        integrations = {
          cmp = true,
          fidget = true,
          gitgutter = true,
          gitsigns = true,
          lsp_trouble = true,
          markdown = true,
          noice = true,
          notify = true,
          nvimtree = true,
          treesitter = true,
        },
      })

      vim.wo.fillchars = "eob: "
      vim.wo.cursorline = true
      vim.cmd.colorscheme("catppuccin")
      if os.getenv("NVIM_TRANSPARENT") == "true" then
        vim.wo.cursorlineopt = "number"
      end
    end,
  },
}

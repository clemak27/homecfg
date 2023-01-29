return {
  require("plugins.ui.bufferline"),
  require("plugins.ui.catppuccin"),
  require("plugins.ui.gitsigns"),
  require("plugins.ui.lualine"),
  require("plugins.ui.noice"),
  require("plugins.ui.nvim-tree"),
  require("plugins.ui.telescope"),
  require("plugins.ui.treesitter"),

  "kyazdani42/nvim-web-devicons",
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
  {
    "petertriho/nvim-scrollbar",
    config = function()
      require("scrollbar").setup({
        handle = {
          color = "#45475A",
        },
      })
    end,
  },
  {
    "RRethy/vim-illuminate",
    config = function()
      require("illuminate").configure({
        delay = 1000,
        filetypes_denylist = { "NvimTree" },
      })
    end,
  },
  "stevearc/dressing.nvim",
}

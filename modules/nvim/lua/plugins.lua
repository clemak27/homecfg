------------------- core plugins -----------------------------------
return {
  "tpope/vim-repeat",
  "tpope/vim-vinegar",
  {
    "inkarkat/vim-ReplaceWithRegister",
    config = function()
      local opt = { noremap = false, silent = true }
      vim.api.nvim_set_keymap("n", "r", "<Plug>ReplaceWithRegisterOperator", opt)
      vim.api.nvim_set_keymap("n", "rr", "<Plug>ReplaceWithRegisterLine", opt)
      vim.api.nvim_set_keymap("n", "R", "r$", opt)
      vim.api.nvim_set_keymap("x", "r", "<Plug>ReplaceWithRegisterVisual", opt)
    end,
  },
  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },
  {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup({
        surrounds = {
          ["C"] = {
            add = { "```", "```" },
          },
        },
        aliases = {
          ["c"] = "`",
        },
      })
    end,
  },
  "antoinemadec/FixCursorHold.nvim",
  {
    "rmagatti/auto-session",
    lazy = false,
    commit = "972d23b2b9615bdd10ad80c225260af4213c3612",
    opts = {
      log_level = "error",
      suppressed_dirs = { "~/", "~/Projects" },
      session_lens = {
        load_on_setup = false,
      },
      cwd_change_handling = false,
    },
  },
  "tpope/vim-fugitive",
}

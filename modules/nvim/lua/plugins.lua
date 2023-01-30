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
    "tpope/vim-commentary",
    config = function()
      vim.api.nvim_create_augroup("nix_comment_fix", { clear = true })
      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = "nix",
        group = "nix_comment_fix",
        callback = function()
          vim.api.nvim_exec([[ setlocal commentstring=#\ %s ]], false)
        end,
      })
    end,
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
  "gpanders/editorconfig.nvim",
  {
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup({
        log_level = "info",
        auto_session_suppress_dirs = { "~/", "~/Projects" },
      })
    end,
  },
  "tpope/vim-fugitive",
  "kana/vim-textobj-user",
  { "kana/vim-textobj-entire", dependencies = "kana/vim-textobj-user" },
  {
    "sgur/vim-textobj-parameter",
    dependencies = "kana/vim-textobj-user",
    config = function()
      vim.g.vim_textobj_parameter_mapping = "a"
    end,
  },
}

-- ---------------------------------------- packer-nvim -------------------------------------------------------

local M = {}

M.load = function()
  local fn = vim.fn

  local function file_exists(name)
    local f = io.open(name, "r")
    if f ~= nil then
      io.close(f)
      return true
    else
      return false
    end
  end

  local function local_path(plugin)
    local plname = string.gsub(plugin, ".+/", "", 1)
    local packer_path = fn.stdpath("data") .. "/site/pack/packer/start/"
    if file_exists(packer_path .. plname) then
      return packer_path .. plname
    end
  end

  require("packer").startup(function(use)
    ----------------- packer --------------------------------------------
    use(local_path("wbthomason/packer.nvim"))

    ----------------- default plugins -----------------------------------
    use("tpope/vim-repeat")
    use("tpope/vim-vinegar")
    use({
      "inkarkat/vim-ReplaceWithRegister",
      config = function()
        local opt = { noremap = false, silent = true }
        vim.api.nvim_set_keymap("n", "r", "<Plug>ReplaceWithRegisterOperator", opt)
        vim.api.nvim_set_keymap("n", "rr", "<Plug>ReplaceWithRegisterLine", opt)
        vim.api.nvim_set_keymap("n", "R", "r$", opt)
        vim.api.nvim_set_keymap("x", "r", "<Plug>ReplaceWithRegisterVisual", opt)
      end,
    })

    use("tpope/vim-commentary")
    vim.api.nvim_create_augroup("nix_comment_fix", { clear = true })
    vim.api.nvim_create_autocmd({ "FileType" }, {
      pattern = "nix",
      group = "nix_comment_fix",
      callback = function()
        vim.api.nvim_exec([[ setlocal commentstring=#\ %s ]], false)
      end,
    })

    use({
      "windwp/nvim-autopairs",
      config = function()
        require("nvim-autopairs").setup({})
      end,
    })
    use({
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
    })
    use("antoinemadec/FixCursorHold.nvim")
    use("gpanders/editorconfig.nvim")
    use({
      "rmagatti/auto-session",
      config = function()
        require("auto-session").setup({
          log_level = "info",
          auto_session_suppress_dirs = { "~/", "~/Projects" },
        })
      end,
    })
    use({
      "kyazdani42/nvim-tree.lua",
      config = function()
        require("nvim-tree-config").load()
      end,
    })

    ----------------- git integration -----------------------------------
    use("tpope/vim-fugitive")
    use({
      "lewis6991/gitsigns.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        require("gitsigns-config").load()
      end,
    })

    ----------------- custom textobjects --------------------------------
    use("kana/vim-textobj-user")
    use("kana/vim-textobj-entire")
    use({
      "sgur/vim-textobj-parameter",
      config = function()
        vim.g.vim_textobj_parameter_mapping = "a"
      end,
    })

    ----------------- theming -------------------------------------------
    use({
      "catppuccin/nvim",
      as = "catppuccin",
      requires = "xiyaowong/nvim-transparent",
      config = function()
        require("colorscheme-config").load()
      end,
    })
    use("kyazdani42/nvim-web-devicons")
    use({
      "nvim-lualine/lualine.nvim",
      config = function()
        require("lualine-config").load()
      end,
    })
    use({
      "akinsho/bufferline.nvim",
      after = "catppuccin",
      config = function()
        require("bufferline-config").load()
      end,
    })
    use({
      "nvim-treesitter/nvim-treesitter",
      config = function()
        require("treesitter-config").load()
      end,
      run = ":TSUpdate",
    })
    use({
      "norcalli/nvim-colorizer.lua",
      config = function()
        require("colorizer").setup()
      end,
    })
    use({
      "petertriho/nvim-scrollbar",
      config = function()
        require("scrollbar").setup({
          handle = {
            color = "#585B70",
          },
        })
      end,
    })
    use({
      "RRethy/vim-illuminate",
      config = function()
        require("illuminate").configure({
          delay = 1000,
          filetypes_denylist = { "NvimTree" },
        })
      end,
    })

    ----------------- markdown ------------------------------------------
    use({
      "preservim/vim-markdown",
      config = function()
        vim.o.conceallevel = 2
        vim.api.nvim_exec(
          [[
          let g:vim_markdown_folding_disabled = 1
          let g:vim_markdown_emphasis_multiline = 0
          let g:vim_markdown_conceal_code_blocks = 0
          let g:vim_markdown_new_list_item_indent = 2
        ]] ,
          false
        )
        vim.api.nvim_set_keymap("n", "<Leader>ww", [[<Cmd>e ~/Notes/index.md<CR>]], { noremap = true, silent = true })
      end,
    })
    use("godlygeek/tabular")
    use({
      "iamcco/markdown-preview.nvim",
      config = function()
        vim.g.mkdp_echo_preview_url = true
      end,
      run = "cd app && yarn install",
    })

    ----------------- vimtex --------------------------------------------
    use({
      "lervag/vimtex",
      config = function()
        vim.g.vimtex_indent_enabled = 1
        vim.g.vimtex_indent_conditionals = {}
        vim.g.vimtex_indent_on_ampersands = 0
        vim.g.vimtex_complete_close_braces = 1
        vim.g.vimtex_format_enabled = 1
        vim.g.vimtex_imaps_leader = ";"
        vim.g.vimtex_quickfix_open_on_warning = 0
      end,
    })

    ----------------- telescope -----------------------------------------------
    use({
      "nvim-telescope/telescope.nvim",
      tag = "0.1.0",
      requires = {
        { "nvim-lua/plenary.nvim" },
      },
      config = function()
        require("telescope-config").load()
      end,
    })
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
    use({ "nvim-telescope/telescope-dap.nvim" })

    use({ "stevearc/dressing.nvim" })
    use({
      "someone-stole-my-name/yaml-companion.nvim",
      config = function()
        require("telescope").load_extension("yaml_schema")
      end,
    })

    ----------------- Mason -----------------------------------------------
    use({
      "williamboman/mason.nvim",
      requires = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
      },
      config = function()
        require("mason-config").load()
      end,
    })

    ----------------- LSP -----------------------------------------------
    use({
      "neovim/nvim-lspconfig",
      requires = {
        "williamboman/mason-lspconfig.nvim",
        "j-hui/fidget.nvim",
      },
      config = function()
        require("lsp-config").load()
      end,
    })
    use({ "mfussenegger/nvim-jdtls" })
    use({
      "jose-elias-alvarez/null-ls.nvim",
      config = function()
        require("null-ls-config").load()
      end,
    })

    ----------------- debugging --------------------------------------
    use({
      "mfussenegger/nvim-dap",
      requires = {
        "leoluz/nvim-dap-go",
        "mxsdev/nvim-dap-vscode-js",
        "theHamsta/nvim-dap-virtual-text",
        "rcarriga/nvim-dap-ui",
      },
      ft = { "go", "java", "javascript", "typescript" },
      config = function()
        require("nvim-dap-config").load()
      end,
    })

    ----------------- cmp -----------------------------------------------
    use({
      "hrsh7th/nvim-cmp",
      requires = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-vsnip",
        "ray-x/cmp-treesitter",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "onsails/lspkind-nvim",
      },
      config = function()
        require("nvim-cmp-config").load()
      end,
    })

    ----------------- snippets ------------------------------------------
    use("hrsh7th/vim-vsnip")
    use("hrsh7th/vim-vsnip-integ")
    use("rafamadriz/friendly-snippets")

    if packer_bootstrap then
      require("packer").sync()
    end
  end)
end

return M

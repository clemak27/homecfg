-- ---------------------------------------- packer-nvim -------------------------------------------------------

local M = {}

M.load = function()

  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
      install_path })
  end

  require('packer').startup(function(use)

    ----------------- packer --------------------------------------------
    use 'wbthomason/packer.nvim'

    ----------------- default plugins -----------------------------------
    use 'tpope/vim-repeat'
    use 'tpope/vim-vinegar'
    use { 'inkarkat/vim-ReplaceWithRegister',
      config = function()
        local opt = { noremap = false, silent = true }
        vim.api.nvim_set_keymap("n", "r", "<Plug>ReplaceWithRegisterOperator", opt)
        vim.api.nvim_set_keymap("n", "rr", "<Plug>ReplaceWithRegisterLine", opt)
        vim.api.nvim_set_keymap("n", "R", "r$", opt)
        vim.api.nvim_set_keymap("x", "r", "<Plug>ReplaceWithRegisterVisual", opt)
      end
    }

    use 'tpope/vim-commentary'
    vim.api.nvim_exec([[
      autocmd FileType nix setlocal commentstring=#\ %s
    ]], false)

    use { 'windwp/nvim-autopairs', config = function() require('nvim-autopairs').setup {} end }
    use { "kylechui/nvim-surround",
      config = function()
        require("nvim-surround").setup {
          surrounds = {
            ["C"] = {
              add = { "```", "```" },
            },
          },
          aliases = {
            ["c"] = "`",
          }
        }
      end
    }
    use 'antoinemadec/FixCursorHold.nvim'
    use 'gpanders/editorconfig.nvim'
    use { 'rmagatti/auto-session',
      config = function()
        require('auto-session').setup {
          log_level = 'info',
          auto_session_suppress_dirs = { '~/', '~/Projects' }
        }
      end
    }
    use { 'kyazdani42/nvim-tree.lua', config = function() require("nvim-tree-config").load() end }

    ----------------- git integration -----------------------------------
    use 'tpope/vim-fugitive'
    use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' },
      config = function() require("gitsigns-config").load() end }

    ----------------- custom textobjects --------------------------------
    use 'kana/vim-textobj-user'
    use 'kana/vim-textobj-entire'
    use { 'sgur/vim-textobj-parameter',
      config = function()
        vim.g.vim_textobj_parameter_mapping = 'a'
      end
    }

    ----------------- theming -------------------------------------------
    use { 'olimorris/onedarkpro.nvim',
      commit = "2c439754e1a60d42197e79461bf04e358213a654",
      config = function() require("colorscheme-config").load() end }
    use 'kyazdani42/nvim-web-devicons'
    use { 'nvim-lualine/lualine.nvim', config = function() require("lualine-config").load() end }
    use { 'akinsho/nvim-bufferline.lua', config = function() require("bufferline-config").load() end }
    use { 'nvim-treesitter/nvim-treesitter', config = function() require("treesitter-config").load() end,
      run = ':TSUpdate' }
    use { 'norcalli/nvim-colorizer.lua', config = function() require('colorizer').setup() end }
    use { 'petertriho/nvim-scrollbar', config = function() require('scrollbar').setup() end }
    use { 'RRethy/vim-illuminate',
      config = function()
        require('illuminate').configure({
          delay = 1000,
          filetypes_denylist = { 'NvimTree' },
        })
      end
    }

    ----------------- markdown ------------------------------------------
    use { 'preservim/vim-markdown',
      config = function()
        vim.o.conceallevel = 2
        vim.api.nvim_exec([[
          let g:vim_markdown_folding_disabled = 1
          let g:vim_markdown_emphasis_multiline = 0
          let g:vim_markdown_conceal_code_blocks = 0
          let g:vim_markdown_new_list_item_indent = 2
        ]], false)
        vim.api.nvim_set_keymap("n", "<Leader>ww", [[<Cmd>e ~/Notes/index.md<CR>]], { noremap = true, silent = true })
      end
    }
    use 'godlygeek/tabular'
    use { 'iamcco/markdown-preview.nvim',
      config = function()
        vim.g.mkdp_echo_preview_url = true
      end,
      run = 'cd app && yarn install'
    }

    ----------------- vimtex --------------------------------------------
    use { 'lervag/vimtex',
      config = function()
        vim.g.vimtex_indent_enabled = 1
        vim.g.vimtex_indent_conditionals = {}
        vim.g.vimtex_indent_on_ampersands = 0
        vim.g.vimtex_complete_close_braces = 1
        vim.g.vimtex_format_enabled = 1
        vim.g.vimtex_imaps_leader = ';'
        vim.g.vimtex_quickfix_open_on_warning = 0
      end
    }

    ----------------- fzf -----------------------------------------------
    use { 'ibhagwan/fzf-lua', config = function() require('fzf-lua-config').load() end }
    use { 'gfanto/fzf-lsp.nvim', config = function() require('fzf_lsp').setup() end }

    ----------------- Mason -----------------------------------------------
    use {
      "williamboman/mason.nvim",
      requires = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim"
      },
      config = function() require('mason-config').load() end
    }

    ----------------- LSP -----------------------------------------------
    use { 'neovim/nvim-lspconfig',
      requires = {
        "williamboman/mason-lspconfig.nvim",
      },
      config = function() require('lsp-config').load() end }
    use { 'ojroques/nvim-lspfuzzy', requires = { 'junegunn/fzf', 'junegunn/fzf.vim' },
      config = function() require('lspfuzzy').setup {} end }
    use { 'mfussenegger/nvim-jdtls' }

    ----------------- go-debugging --------------------------------------
    use { 'mfussenegger/nvim-dap',
      requires = { 'leoluz/nvim-dap-go', 'theHamsta/nvim-dap-virtual-text', 'rcarriga/nvim-dap-ui' },
      ft = { 'go' },
      config = function() require('nvim-dap-config').load() end
    }

    ----------------- cmp -----------------------------------------------
    use { 'hrsh7th/nvim-cmp',
      requires = { 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path', 'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-vsnip', 'ray-x/cmp-treesitter', 'hrsh7th/cmp-nvim-lsp-signature-help', 'onsails/lspkind-nvim' },
      config = function() require('nvim-cmp-config').load() end
    }

    ----------------- snippets ------------------------------------------
    use 'hrsh7th/vim-vsnip'
    use 'hrsh7th/vim-vsnip-integ'
    use 'rafamadriz/friendly-snippets'

    ----------------- lint ----------------------------------------------
    use { 'jose-elias-alvarez/null-ls.nvim',
      config = function() require('null-ls-config').load() end
    }

    if packer_bootstrap then
      require('packer').sync()
    end
  end)

end

return M

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

  local function local_path_opt(plugin)
    local plname = string.gsub(plugin, ".+/", "", 1)
    local packer_path = fn.stdpath("data") .. "/site/pack/packer/opt/"
    if file_exists(packer_path .. plname) then
      return packer_path .. plname
    end
  end

  require("packer").startup(function(use)
    ----------------- packer --------------------------------------------
    use(local_path("wbthomason/packer.nvim"))

    ----------------- default plugins -----------------------------------
    use(local_path("tpope/vim-repeat"))
    use(local_path("tpope/vim-vinegar"))
    use({
      local_path("inkarkat/vim-ReplaceWithRegister"),
      config = function()
        local opt = { noremap = false, silent = true }
        vim.api.nvim_set_keymap("n", "r", "<Plug>ReplaceWithRegisterOperator", opt)
        vim.api.nvim_set_keymap("n", "rr", "<Plug>ReplaceWithRegisterLine", opt)
        vim.api.nvim_set_keymap("n", "R", "r$", opt)
        vim.api.nvim_set_keymap("x", "r", "<Plug>ReplaceWithRegisterVisual", opt)
      end,
    })

    use(local_path("tpope/vim-commentary"))
    vim.api.nvim_create_augroup("nix_comment_fix", { clear = true })
    vim.api.nvim_create_autocmd({ "FileType" }, {
      pattern = "nix",
      group = "nix_comment_fix",
      callback = function()
        vim.api.nvim_exec([[ setlocal commentstring=#\ %s ]], false)
      end,
    })

    use({
      local_path("windwp/nvim-autopairs"),
      config = function()
        require("nvim-autopairs").setup({})
      end,
    })
    use({
      local_path("kylechui/nvim-surround"),
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
    use(local_path("antoinemadec/FixCursorHold.nvim"))
    use(local_path("gpanders/editorconfig.nvim"))
    use({
      local_path("rmagatti/auto-session"),
      config = function()
        require("auto-session").setup({
          log_level = "info",
          auto_session_suppress_dirs = { "~/", "~/Projects" },
        })
      end,
    })
    use({
      local_path("kyazdani42/nvim-tree.lua"),
      config = function()
        require("nvim-tree-config").load()
      end,
    })

    ----------------- git integration -----------------------------------
    use(local_path("tpope/vim-fugitive"))
    use({
      local_path("lewis6991/gitsigns.nvim"),
      requires = { local_path("nvim-lua/plenary.nvim") },
      config = function()
        require("gitsigns-config").load()
      end,
    })

    ----------------- custom textobjects --------------------------------
    use(local_path("kana/vim-textobj-user"))
    use(local_path("kana/vim-textobj-entire"))
    use({
      local_path("sgur/vim-textobj-parameter"),
      config = function()
        vim.g.vim_textobj_parameter_mapping = "a"
      end,
    })

    ----------------- theming -------------------------------------------
    use({
      local_path("catppuccin"),
      requires = local_path("xiyaowong/nvim-transparent"),
      config = function()
        require("colorscheme-config").load()
      end,
    })
    use(local_path("kyazdani42/nvim-web-devicons"))
    use({
      local_path("nvim-lualine/lualine.nvim"),
      config = function()
        require("lualine-config").load()
      end,
    })
    use({
      local_path_opt("akinsho/bufferline.nvim"),
      after = "catppuccin",
      config = function()
        require("bufferline-config").load()
      end,
    })
    use({
      "nvim-treesitter/nvim-treesitter",
      -- local_path("nvim-treesitter/nvim-treesitter"),
      config = function()
        require("treesitter-config").load()
      end,
      -- run = ":TSUpdateSync",
    })
    use({
      local_path("norcalli/nvim-colorizer.lua"),
      config = function()
        require("colorizer").setup()
      end,
    })
    use({
      local_path("petertriho/nvim-scrollbar"),
      config = function()
        require("scrollbar").setup({
          handle = {
            color = "#585B70",
          },
        })
      end,
    })
    use({
      local_path("RRethy/vim-illuminate"),
      config = function()
        require("illuminate").configure({
          delay = 1000,
          filetypes_denylist = { "NvimTree" },
        })
      end,
    })

    ----------------- markdown ------------------------------------------
    use({
      local_path("preservim/vim-markdown"),
      config = function()
        vim.o.conceallevel = 2
        vim.api.nvim_exec(
          [[
          let g:vim_markdown_folding_disabled = 1
          let g:vim_markdown_emphasis_multiline = 0
          let g:vim_markdown_conceal_code_blocks = 0
          let g:vim_markdown_new_list_item_indent = 2
        ]],
          false
        )
        vim.api.nvim_set_keymap("n", "<Leader>ww", [[<Cmd>e ~/Notes/index.md<CR>]], { noremap = true, silent = true })
      end,
    })
    use(local_path("godlygeek/tabular"))
    use({
      local_path("iamcco/markdown-preview.nvim"),
      config = function()
        vim.g.mkdp_echo_preview_url = true
      end,
      run = "cd app && yarn install",
    })

    ----------------- vimtex --------------------------------------------
    use({
      local_path("lervag/vimtex"),
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

    ----------------- fzf -----------------------------------------------
    use({
      local_path("ibhagwan/fzf-lua"),
      config = function()
        require("fzf-lua-config").load()
      end,
    })
    use({
      local_path("gfanto/fzf-lsp.nvim"),
      config = function()
        require("fzf_lsp").setup()
      end,
    })

    ----------------- Mason -----------------------------------------------
    use({
      local_path("williamboman/mason.nvim"),
      requires = {
        local_path("williamboman/mason-lspconfig.nvim"),
        local_path("WhoIsSethDaniel/mason-tool-installer.nvim"),
      },
      config = function()
        require("mason-config").load()
      end,
    })

    ----------------- LSP -----------------------------------------------
    use({
      local_path("neovim/nvim-lspconfig"),
      requires = {
        local_path("williamboman/mason-lspconfig.nvim"),
        local_path("j-hui/fidget.nvim"),
        { local_path("glepnir/lspsaga.nvim"), branch = "main" },
      },
      config = function()
        require("lsp-config").load()
      end,
    })
    use({
      local_path("ojroques/nvim-lspfuzzy"),
      requires = { local_path("junegunn/fzf"), local_path("junegunn/fzf.vim") },
      config = function()
        require("lspfuzzy").setup({})
      end,
    })
    use({ local_path("mfussenegger/nvim-jdtls") })
    use({
      local_path("jose-elias-alvarez/null-ls.nvim"),
      config = function()
        require("null-ls-config").load()
      end,
    })

    ----------------- debugging --------------------------------------
    use({
      local_path_opt("mfussenegger/nvim-dap"),
      requires = {
        local_path("leoluz/nvim-dap-go"),
        local_path("mxsdev/nvim-dap-vscode-js"),
        local_path("theHamsta/nvim-dap-virtual-text"),
        local_path("rcarriga/nvim-dap-ui"),
      },
      ft = { "go", "java", "javascript", "typescript" },
      config = function()
        require("nvim-dap-config").load()
      end,
    })

    ----------------- cmp -----------------------------------------------
    use({
      local_path("hrsh7th/nvim-cmp"),
      requires = {
        local_path("hrsh7th/cmp-nvim-lsp"),
        local_path("hrsh7th/cmp-buffer"),
        local_path("hrsh7th/cmp-path"),
        local_path("hrsh7th/cmp-cmdline"),
        local_path("hrsh7th/cmp-vsnip"),
        local_path("ray-x/cmp-treesitter"),
        local_path("hrsh7th/cmp-nvim-lsp-signature-help"),
        local_path("onsails/lspkind-nvim"),
      },
      config = function()
        require("nvim-cmp-config").load()
      end,
    })

    ----------------- snippets ------------------------------------------
    use(local_path("hrsh7th/vim-vsnip"))
    use(local_path("hrsh7th/vim-vsnip-integ"))
    use(local_path("rafamadriz/friendly-snippets"))

    if packer_bootstrap then
      require("packer").sync()
    end
  end)
end

return M

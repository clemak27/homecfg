{
  inputs =
    {
      # packer
      packer-nvim = { url = "github:wbthomason/packer.nvim"; flake = false; };
      # basic plugins
      vim-repeat = { url = "github:tpope/vim-repeat"; flake = false; };
      vim-vinegar = { url = "github:tpope/vim-vinegar"; flake = false; };
      vim-ReplaceWithRegister = { url = "github:inkarkat/vim-ReplaceWithRegister"; flake = false; };
      vim-commentary = { url = "github:tpope/vim-commentary"; flake = false; };
      nvim-autopairs = { url = "github:windwp/nvim-autopairs"; flake = false; };
      nvim-surround = { url = "github:kylechui/nvim-surround"; flake = false; };
      FixCursorHold-nvim = { url = "github:antoinemadec/FixCursorHold.nvim"; flake = false; };
      editorconfig-nvim = { url = "github:gpanders/editorconfig.nvim"; flake = false; };
      auto-session = { url = "github:rmagatti/auto-session"; flake = false; };
      nvim-tree-lua = { url = "github:kyazdani42/nvim-tree.lua"; flake = false; };
      # git integration
      vim-fugitive = { url = "github:tpope/vim-fugitive"; flake = false; };
      gitsigns-nvim = { url = "github:lewis6991/gitsigns.nvim"; flake = false; };
      plenary-nvim = { url = "github:nvim-lua/plenary.nvim"; flake = false; };
      # custom textobjects
      vim-textobj-user = { url = "github:kana/vim-textobj-user"; flake = false; };
      vim-textobj-entire = { url = "github:kana/vim-textobj-entire"; flake = false; };
      vim-textobj-parameter = { url = "github:sgur/vim-textobj-parameter"; flake = false; };
      # theming
      catppuccin = { url = "github:catppuccin/nvim"; flake = false; };
      nvim-transparent = { url = "github:xiyaowong/nvim-transparent"; flake = false; };
      nvim-web-devicons = { url = "github:kyazdani42/nvim-web-devicons"; flake = false; };
      lualine-nvim = { url = "github:nvim-lualine/lualine.nvim"; flake = false; };
      bufferline-nvim = { url = "github:akinsho/bufferline.nvim"; flake = false; };
      # nvim-treesitter = { url = "github:nvim-treesitter/nvim-treesitter"; flake = false; };
      nvim-colorizer-lua = { url = "github:norcalli/nvim-colorizer.lua"; flake = false; };
      nvim-scrollbar = { url = "github:petertriho/nvim-scrollbar"; flake = false; };
      vim-illuminate = { url = "github:RRethy/vim-illuminate"; flake = false; };
      # markdown
      vim-markdown = { url = "github:preservim/vim-markdown"; flake = false; };
      tabular = { url = "github:godlygeek/tabular"; flake = false; };
      markdown-preview-nvim = { url = "github:iamcco/markdown-preview.nvim"; flake = false; };
      # vimtex
      vimtex = { url = "github:lervag/vimtex"; flake = false; };
      # fzf
      fzf-lua = { url = "github:ibhagwan/fzf-lua"; flake = false; };
      fzf-lsp-nvim = { url = "github:gfanto/fzf-lsp.nvim"; flake = false; };
      # mason
      mason-nvim = { url = "github:williamboman/mason.nvim"; flake = false; };
      mason-lspconfig-nvim = { url = "github:williamboman/mason-lspconfig.nvim"; flake = false; };
      mason-tool-installer-nvim = { url = "github:WhoIsSethDaniel/mason-tool-installer.nvim"; flake = false; };
      # LSP
      nvim-lspconfig = { url = "github:neovim/nvim-lspconfig"; flake = false; };
      # mason-lspconfig-nvim = { url = "github:williamboman/mason-lspconfig.nvim"; flake = false; };
      fidget-nvim = { url = "github:j-hui/fidget.nvim"; flake = false; };
      lspsaga-nvim = { url = "github:glepnir/lspsaga.nvim"; flake = false; };
      nvim-lspfuzzy = { url = "github:ojroques/nvim-lspfuzzy"; flake = false; };
      fzf = { url = "github:junegunn/fzf"; flake = false; };
      fzf-vim = { url = "github:junegunn/fzf.vim"; flake = false; };
      nvim-jdtls = { url = "github:mfussenegger/nvim-jdtls"; flake = false; };
      null-ls-nvim = { url = "github:jose-elias-alvarez/null-ls.nvim"; flake = false; };
      # debugging
      nvim-dap = { url = "github:mfussenegger/nvim-dap"; flake = false; };
      nvim-dap-go = { url = "github:leoluz/nvim-dap-go"; flake = false; };
      nvim-dap-vscode-js = { url = "github:mxsdev/nvim-dap-vscode-js"; flake = false; };
      nvim-dap-virtual-text = { url = "github:theHamsta/nvim-dap-virtual-text"; flake = false; };
      nvim-dap-ui = { url = "github:rcarriga/nvim-dap-ui"; flake = false; };
      # cmp
      nvim-cmp = { url = "github:hrsh7th/nvim-cmp"; flake = false; };
      cmp-nvim-lsp = { url = "github:hrsh7th/cmp-nvim-lsp"; flake = false; };
      cmp-buffer = { url = "github:hrsh7th/cmp-buffer"; flake = false; };
      cmp-path = { url = "github:hrsh7th/cmp-path"; flake = false; };
      cmp-cmdline = { url = "github:hrsh7th/cmp-cmdline"; flake = false; };
      cmp-vsnip = { url = "github:hrsh7th/cmp-vsnip"; flake = false; };
      cmp-treesitter = { url = "github:ray-x/cmp-treesitter"; flake = false; };
      cmp-nvim-lsp-signature-help = { url = "github:hrsh7th/cmp-nvim-lsp-signature-help"; flake = false; };
      lspkind-nvim = { url = "github:onsails/lspkind-nvim"; flake = false; };
      # snippets
      vim-vsnip = { url = "github:hrsh7th/vim-vsnip"; flake = false; };
      vim-vsnip-integ = { url = "github:hrsh7th/vim-vsnip-integ"; flake = false; };
      friendly-snippets = { url = "github:rafamadriz/friendly-snippets"; flake = false; };
    };

  outputs = { self, ... }: {
    nixosModules = {
      homecfg = import ./default.nix;
      nvim-plugins = { config, lib, pkgs, ... }:
        let
          packer_dir     = ".local/share/nvim/site/pack/packer/start/";
          packer_opt_dir = ".local/share/nvim/site/pack/packer/opt/";
        in
        {
          # packer
          home.file."${packer_dir}packer.nvim".source = self.inputs.packer-nvim.outPath;
          # basic plugins
          home.file."${packer_dir}vim-repeat".source = self.inputs.vim-repeat.outPath;
          home.file."${packer_dir}vim-vinegar".source = self.inputs.vim-vinegar.outPath;
          home.file."${packer_dir}vim-ReplaceWithRegister".source = self.inputs.vim-ReplaceWithRegister.outPath;
          home.file."${packer_dir}vim-commentary".source = self.inputs.vim-commentary.outPath;
          home.file."${packer_dir}nvim-autopairs".source = self.inputs.nvim-autopairs.outPath;
          home.file."${packer_dir}nvim-surround".source = self.inputs.nvim-surround.outPath;
          home.file."${packer_dir}FixCursorHold.nvim".source = self.inputs.FixCursorHold-nvim.outPath;
          home.file."${packer_dir}editorconfig.nvim".source = self.inputs.editorconfig-nvim.outPath;
          home.file."${packer_dir}auto-session".source = self.inputs.auto-session.outPath;
          home.file."${packer_dir}nvim-tree.lua".source = self.inputs.nvim-tree-lua.outPath;
          # git integration
          home.file."${packer_dir}vim-fugitive".source = self.inputs.vim-fugitive.outPath;
          home.file."${packer_dir}gitsigns.nvim".source = self.inputs.gitsigns-nvim.outPath;
          home.file."${packer_dir}plenary.nvim".source = self.inputs.plenary-nvim.outPath;
          # custom textobjects
          home.file."${packer_dir}vim-textobj-user".source = self.inputs.vim-textobj-user.outPath;
          home.file."${packer_dir}vim-textobj-entire".source = self.inputs.vim-textobj-entire.outPath;
          home.file."${packer_dir}vim-textobj-parameter".source = self.inputs.vim-textobj-parameter.outPath;
          # theming
          home.file."${packer_dir}catppuccin".source = self.inputs.catppuccin.outPath;
          home.file."${packer_dir}nvim-transparent".source = self.inputs.nvim-transparent.outPath;
          home.file."${packer_dir}nvim-web-devicons".source = self.inputs.nvim-web-devicons.outPath;
          home.file."${packer_dir}lualine.nvim".source = self.inputs.lualine-nvim.outPath;
          home.file."${packer_opt_dir}bufferline.nvim".source = self.inputs.bufferline-nvim.outPath;
          # home.file."${packer_dir}nvim-treesitter" =  {
          #   source = self.inputs.nvim-treesitter.outPath;
          #   recursive = true;
          # };
          home.file."${packer_dir}nvim-colorizer.lua".source = self.inputs.nvim-colorizer-lua.outPath;
          home.file."${packer_dir}nvim-scrollbar".source = self.inputs.nvim-scrollbar.outPath;
          home.file."${packer_dir}vim-illuminate".source = self.inputs.vim-illuminate.outPath;
          # markdown
          home.file."${packer_dir}vim-markdown".source = self.inputs.vim-markdown.outPath;
          home.file."${packer_dir}tabular".source = self.inputs.tabular.outPath;
          home.file."${packer_dir}markdown-preview.nvim".source = self.inputs.markdown-preview-nvim.outPath;
          # vimtex
          home.file."${packer_dir}vimtex".source = self.inputs.vimtex.outPath;
          # fzf
          home.file."${packer_dir}fzf-lua".source = self.inputs.fzf-lua.outPath;
          home.file."${packer_dir}fzf-lsp.nvim".source = self.inputs.fzf-lsp-nvim.outPath;
          # mason
          home.file."${packer_dir}mason.nvim".source = self.inputs.mason-nvim.outPath;
          home.file."${packer_dir}mason-lspconfig.nvim".source = self.inputs.mason-lspconfig-nvim.outPath;
          home.file."${packer_dir}mason-tool-installer.nvim".source = self.inputs.mason-tool-installer-nvim.outPath;
          # LSP
          home.file."${packer_dir}nvim-lspconfig".source = self.inputs.nvim-lspconfig.outPath;
          # home.file."${packer_dir}mason-lspconfig.nvim".source = self.inputs.mason-lspconfig-nvim.outPath;
          home.file."${packer_dir}fidget.nvim".source = self.inputs.fidget-nvim.outPath;
          home.file."${packer_dir}lspsaga.nvim".source = self.inputs.lspsaga-nvim.outPath;
          home.file."${packer_dir}nvim-lspfuzzy".source = self.inputs.nvim-lspfuzzy.outPath;
          home.file."${packer_dir}fzf".source = self.inputs.fzf.outPath;
          home.file."${packer_dir}fzf.vim".source = self.inputs.fzf-vim.outPath;
          home.file."${packer_dir}nvim-jdtls".source = self.inputs.nvim-jdtls.outPath;
          home.file."${packer_dir}null-ls.nvim".source = self.inputs.null-ls-nvim.outPath;
          # debugging
          home.file."${packer_opt_dir}nvim-dap".source = self.inputs.nvim-dap.outPath;
          home.file."${packer_dir}nvim-dap-go".source = self.inputs.nvim-dap-go.outPath;
          home.file."${packer_dir}nvim-dap-vscode-js".source = self.inputs.nvim-dap-vscode-js.outPath;
          home.file."${packer_dir}nvim-dap-virtual-text".source = self.inputs.nvim-dap-virtual-text.outPath;
          home.file."${packer_dir}nvim-dap-ui".source = self.inputs.nvim-dap-ui.outPath;
          # cmp
          home.file."${packer_dir}nvim-cmp".source = self.inputs.nvim-cmp.outPath;
          home.file."${packer_dir}cmp-nvim-lsp".source = self.inputs.cmp-nvim-lsp.outPath;
          home.file."${packer_dir}cmp-buffer".source = self.inputs.cmp-buffer.outPath;
          home.file."${packer_dir}cmp-path".source = self.inputs.cmp-path.outPath;
          home.file."${packer_dir}cmp-cmdline".source = self.inputs.cmp-cmdline.outPath;
          home.file."${packer_dir}cmp-vsnip".source = self.inputs.cmp-vsnip.outPath;
          home.file."${packer_dir}cmp-treesitter".source = self.inputs.cmp-treesitter.outPath;
          home.file."${packer_dir}cmp-nvim-lsp-signature-help".source = self.inputs.cmp-nvim-lsp-signature-help.outPath;
          home.file."${packer_dir}lspkind-nvim".source = self.inputs.lspkind-nvim.outPath;
          # snippets
          home.file."${packer_dir}vim-vsnip".source = self.inputs.vim-vsnip.outPath;
          home.file."${packer_dir}vim-vsnip-integ".source = self.inputs.vim-vsnip-integ.outPath;
          home.file."${packer_dir}friendly-snippets".source = self.inputs.friendly-snippets.outPath;
        };
    };
  };
}

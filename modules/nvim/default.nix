{ config, lib, pkgs, ... }:
let
  cfg = config.homecfg.nvim;
  treesitter = pkgs.tree-sitter.override {
    extraGrammars = with lib; filterAttrs (n: _: hasPrefix "tree-sitter-" n) sources;
  };
in
{
  options.homecfg.nvim.enable = lib.mkEnableOption "Manage neovim with homecfg";

  config = lib.mkIf (cfg.enable) {

    programs.zsh.shellAliases = builtins.listToAttrs (
      [
        { name = "nps"; value = "nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'"; }
      ]
    );

    programs.neovim = {
      enable = true;
      withNodeJs = true;
      vimAlias = true;
      vimdiffAlias = true;
    };

    home.packages = with pkgs; [
      cargo
      rnix-lsp
    ];

    home.file = {
      ".markdownlintrc".source = ./markdownlintrc;
      ".vsnip".source = ./vsnip;
      ".local/share/nvim/site/parser".source = "${treesitter.withPlugins (_: treesitter.allGrammars)}";
    };
    xdg.configFile = {
      "nvim/init.lua".source = ./init.lua;
      "nvim/lua".source = ./lua;
      "nvim/ftplugin".source = ./ftplugin;
    };
  };
}

{ config, lib, pkgs, ... }:
let
  cfg = config.homecfg.nvim;
in
{
  options.homecfg.nvim.enable = lib.mkEnableOption "Manage neovim with homecfg";

  config = lib.mkIf (cfg.enable) {

    programs.neovim = {
      enable = true;
      withNodeJs = true;
      vimAlias = true;
      vimdiffAlias = true;
      extraPackages = with pkgs; [
        cargo
        gcc
        nodejs-16_x
        rnix-lsp
        sumneko-lua-language-server
        yarn
      ];
    };

    home.file = {
      ".markdownlintrc".source = ./markdownlintrc;
      ".vsnip".source = ./vsnip;
    };
    xdg.configFile = {
      "nvim/init.lua".source = ./init.lua;
      "nvim/lua".source = ./lua;
      "nvim/ftplugin".source = ./ftplugin;
    };
  };
}

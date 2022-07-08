{ config, lib, pkgs, ... }:
let
  cfg = config.homecfg.nvim;
in
{
  options.homecfg.nvim.enable = lib.mkEnableOption "Manage neovim with homecfg";

  config = lib.mkIf (cfg.enable) {

    programs.zsh.shellAliases = builtins.listToAttrs (
      [
        { name = "notes"; value = "nvim ~/Notes/index.md"; }
        { name = "vi"; value = "nvim"; }
        { name = "vim"; value = "nvim"; }
      ]
    );

    home.packages = with pkgs; [
      nodePackages.eslint
      nodePackages.markdownlint-cli
      vale
      cargo
      shellcheck

      # add neovim as normal package as a workaround for
      # https://github.com/nix-community/home-manager/issues/1907
      neovim
    ];

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

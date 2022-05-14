{ config, lib, pkgs, ... }:
{
  imports = [
    ./colors.nix
    ./modules/dev
    ./modules/fun
    ./modules/k8s
    ./modules/git
    ./modules/nvim
    ./modules/tmux
    ./modules/tools
    ./modules/zsh
  ];

  options.homecfg.NixOS = {
    enable = lib.mkEnableOption "Set to true if running on NixOS";
  };

  config = {
    programs.home-manager.enable = true;
    nixpkgs.config.allowUnfree = true;
  };

}

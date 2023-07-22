{ config, lib, pkgs, ... }:
{
  imports = [
    ./modules/dev
    ./modules/fun
    ./modules/git
    ./modules/k8s
    ./modules/nvim
    ./modules/tmux
    ./modules/tools
    ./modules/zsh
  ];

  config = {
    programs.home-manager.enable = true;
    nixpkgs.config.allowUnfree = true;
  };

}

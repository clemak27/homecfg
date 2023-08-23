{ config, lib, pkgs, ... }:
let
  cfg = config.homecfg;
in
{
  imports = [
    ./hx.nix
    ./nvim.nix
  ];

  options.homecfg.zellij = {
    enable = lib.mkEnableOption "Manage zellij with home-manager";
  };

  config = lib.mkIf (cfg.zellij.enable) {

    programs.zellij = {
      enable = true;
      # enableZshIntegration = true;
    };

    xdg.configFile = {
      "zellij/config.kdl".source = ./config.kdl;
      "zellij/layouts/custom.kdl".source = ./custom.kdl;
      "zellij/layouts/notes.kdl".source = ./notes.kdl;
      "zellij/custom-zellij-bar.wasm".source = ./custom-zellij-bar.wasm;
    };
  };
}

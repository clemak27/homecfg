{ config, lib, pkgs, ... }:
let
  cfg = config.homecfg;
in
{
  config = lib.mkIf (cfg.nvim.enable) {

    xdg.configFile = {
      "zellij/layouts/dev.kdl".source = ./devNvim.kdl;
    };

  };
}

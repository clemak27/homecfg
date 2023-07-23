{ config, lib, pkgs, ... }:
let
  cfg = config.homecfg;
in
{
  options.homecfg.zellij = {
    enable = lib.mkEnableOption "Manage zellij with home-manager";
  };

  config = lib.mkIf (cfg.zellij.enable) {

    programs.zellij = {
      enable = true;
      # enableZshIntegration = true;
    };

    xdg.configFile = {
      "zellij/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "/home/clemens/Projects/homecfg/modules/zellij/config.kdl";
      "zellij/layouts/custom.kdl".source = config.lib.file.mkOutOfStoreSymlink "/home/clemens/Projects/homecfg/modules/zellij/custom.kdl";
    };
  };
}

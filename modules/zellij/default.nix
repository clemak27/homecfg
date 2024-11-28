{ pkgs, config, lib, ... }:
let
  cfg = config.homecfg;
in
{
  options.homecfg.zellij = {
    enable = lib.mkEnableOption "Manage zellij with home-manager";

    zjstatusOptions = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Settings for zjStatus";
      example = '' {
            k8s_enable  true
        }
      '';
    };
  };

  config = lib.mkIf (cfg.zellij.enable) {

    programs.zellij = {
      enable = true;
    };

    xdg.configFile = {
      "zellij/config.kdl".source = ./config.kdl;

      "zellij/layouts/custom.kdl".text = ''
        layout {
          pane size=1 borderless=true {
              plugin location="file:${pkgs.zjstatus}/bin/zjstatus.wasm" ${cfg.zellij.zjstatusOptions}
          }
          pane {
            borderless true
          }
        }
      '';
    };
  };
}

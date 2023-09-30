{ config, lib, pkgs, ... }:
let
  cfg = config.homecfg;
in
{
  config = lib.mkIf (cfg.nvim.enable) {

    xdg.configFile = {
      "zellij/layouts/dev.kdl".text = ''
        layout {
            pane size=1 borderless=true {
                plugin location="${cfg.zellij.bar}"
            }
            pane split_direction="vertical" size="80%"{
                pane {
                    // command "nvim"
                    focus true
                    name "nvim"
                }
            }
            pane
        }
      '';
    };
  };
}

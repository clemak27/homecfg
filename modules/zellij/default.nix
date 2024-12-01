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
      enableZshIntegration = false;
    };

    xdg.configFile = {
      "zellij/config.kdl".text = ''
        plugins {
            tab-bar location="zellij:tab-bar"
            status-bar location="file:${pkgs.zjstatus}/bin/zjstatus.wasm"
            strider location="zellij:strider"
            compact-bar location="file:${pkgs.zjstatus}/bin/zjstatus.wasm"
            session-manager location="zellij:session-manager"
            welcome-screen location="zellij:session-manager" {
                welcome_screen true
            }
            filepicker location="zellij:strider" {
                cwd "/"
            }
        }

        theme "catppuccin-mocha"

        default_layout "custom"
        scroll_buffer_size 20000

        pane_frames false

        keybinds {
            unbind "Ctrl b"
            pane {
                bind "c" { Clear; SwitchToMode "Normal"; }
            }
            move {
                bind "Ctrl m" { SwitchToMode "Normal"; }
            }
            scroll {
                bind "c" { Clear; }
            }
            tmux clear-defaults=true {
            }
            shared_except "locked" {
                unbind "Ctrl q"
                unbind "Alt f"
                unbind "Alt i"
                unbind "Alt o"
            }
            shared_except "move" "locked" {
                unbind "Ctrl h"
                bind "Ctrl q" { SwitchToMode "Move"; }
            }
            shared_except "tmux" "locked" {
            }
        }
      '';

      "zellij/layouts/custom.kdl".text = ''
        layout {
          pane size=1 borderless=true {
              plugin location="compact-bar" ${cfg.zellij.zjstatusOptions}
          }
          pane {
            borderless true
          }
        }
      '';
    };
  };
}

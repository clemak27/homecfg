{ config, lib, ... }:
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

    bar = lib.mkOption {
      type = lib.types.str;
      default = "zellij:compact-bar";
      description = "Which statusbar to use. Needs to be prefixed with `file:`";
      example = "file:~/.config/zellij/custom-zellij-bar.wasm";
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
            plugin location="${cfg.zellij.bar}"
          }
          pane {
            borderless false
              cwd "~"
          }
        }
      '';
    };
  };
}

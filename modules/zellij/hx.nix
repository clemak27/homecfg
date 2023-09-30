{ config, lib, pkgs, ... }:
let
  cfg = config.homecfg;
  sidetree = pkgs.rustPlatform.buildRustPackage rec {
    pname = "sidetree";
    version = "v0.8.2";

    src = pkgs.fetchFromGitHub {
      owner = "topisani";
      repo = pname;
      rev = version;
      hash = "sha256-3Pq1Ta3BgE68Z9de9b11Im+Zrm1vZxhNHf1rWDAT34g";
    };

    cargoSha256 = "sha256-4W1M3Y4lckQU5t7kaYJqOwkF6nFlTYWUBfC2LVUkKI8=";
  };

  zellijHelixSideTree = pkgs.writeShellScriptBin "zhst" ''
    zellij run -c -f -d left -- sidetree
  '';
in
{
  config = lib.mkIf (cfg.helix.enable) {

    home.packages = [
      sidetree
      zellijHelixSideTree
    ];

    xdg.configFile = {
      "zellij/layouts/dev.kdl".text = ''
        layout {
            pane size=1 borderless=true {
                plugin location="${cfg.zellij.bar}"
            }
            pane split_direction="vertical" size="80%"{
                pane {
                    command "sidetree"
                    close_on_exit true
                    size "15%"
                }
                pane {
                    command "hx"
                    args "."
                    focus true
                    name "helix"
                }
            }
            pane
        }

      '';


      "sidetree/sidetreerc".text = ''
        set show_hidden true
        set quit_on_open false
        set open_cmd 'zellij action move-focus right && zellij action write-chars ":open $sidetree_entry"'

        set file_icons false
        set icon_style white
        set dir_name_style lightblue+b
        set file_name_style reset
        set highlight_style +r
        set link_style cyan+b
      '';
    };

  };
}

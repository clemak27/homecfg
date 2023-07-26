{ config, lib, pkgs, ... }:
let
  cfg = config.homecfg;

  zellijLazygit = pkgs.writeShellScriptBin "zlg" ''
    zellij run -c -- lazygit && zellij action toggle-fullscreen
  '';

  zellijOpenProject = pkgs.writeShellScriptBin "zpf" ''
    path=$(fd --type=d --hidden ".git" --exclude gitea-repos --absolute-path $HOME/Projects | grep ".git/" | sd "/.git/" "" | fzf)
    if [ "$path" != "" ]; then
      pname=$(basename $path)
      zellij action new-tab --cwd $path --name $pname --layout dev
    fi
  '';

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
  options.homecfg.zellij = {
    enable = lib.mkEnableOption "Manage zellij with home-manager";
  };

  config = lib.mkIf (cfg.zellij.enable) {

    programs.zellij = {
      enable = true;
      # enableZshIntegration = true;
    };

    home.packages = [
      sidetree
      zellijHelixSideTree
      zellijLazygit
      zellijOpenProject
    ];

    xdg.configFile = {
      "zellij/config.kdl".source = ./config.kdl;
      "zellij/layouts/custom.kdl".source = ./custom.kdl;
      "zellij/layouts/dev.kdl".source = ./dev.kdl;
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

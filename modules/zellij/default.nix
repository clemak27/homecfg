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
in
{
  imports = [
    ./hx.nix
  ];

  options.homecfg.zellij = {
    enable = lib.mkEnableOption "Manage zellij with home-manager";
  };

  config = lib.mkIf (cfg.zellij.enable) {

    programs.zellij = {
      enable = true;
      # enableZshIntegration = true;
    };

    home.packages = [
      zellijLazygit
      zellijOpenProject
    ];

    xdg.configFile = {
      "zellij/config.kdl".source = ./config.kdl;
      "zellij/layouts/custom.kdl".source = ./custom.kdl;
    };
  };
}

{ config, lib, pkgs, ... }:
let
  catppuccinK9s = builtins.fetchGit {
    url = "https://github.com/catppuccin/k9s";
    ref = "main";
    rev = "322598e19a4270298b08dc2765f74795e23a1615";
  };
  cfg = config.homecfg.k8s;
in
{
  options.homecfg.k8s.k9s = lib.mkEnableOption "Install k9s";

  config = lib.mkIf (cfg.k9s) {
    programs.k9s = {
      enable = true;
      settings = {
        k9s = {
          headless = true;
          enableMouse = true;
        };
      };
    };

    programs.zsh.shellAliases = builtins.listToAttrs (
      [
        { name = "k9s"; value = "K9SCONFIG=~/.config/k9s k9s"; }
      ]
    );

    xdg.configFile = {
      "k9s/skin.yml".source = "${catppuccinK9s}/dist/mocha.yml";
      "k9s/views.yml".text = ''
        k9s:
          views:
            v1/pods:
              columns:
                - NAMESPACE
                - NAME
                - STATUS
                - READY
                - AGE
      '';
    };

  };
}

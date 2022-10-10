{ config, lib, pkgs, ... }:
let
  cfg = config.homecfg.dev;
in
{
  options.homecfg.dev.enable = lib.mkEnableOption "Manage development tools with home-manager";

  config = lib.mkIf (cfg.enable) {
    home.packages = with pkgs; [
      nodejs-14_x
      yarn

      gradle

      gcc
      gnumake
    ];

    programs.zsh.oh-my-zsh.plugins = [
      "npm"
      "golang"
      "gradle-completion"
    ];

    home.file.".oh-my-zsh/custom/plugins/gradle-completion".source =
      builtins.fetchGit {
        url = "https://github.com/gradle/gradle-completion";
        ref = "master";
        rev = "b042038e3d3b30a6440c121268894234c509ca1c";
      };

    home.file.".npmrc".text = ''
      prefix=~/.local/bin/npm
      save-exact=true
    '';

    programs.java = {
      enable = true;
      package = pkgs.jdk11;
    };

    programs.go = {
      enable = true;
      package = pkgs.go_1_19;
      goPath = ".go";
    };

  };

}

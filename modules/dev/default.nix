{ config, lib, pkgs, ... }:
let
  cfg = config.homecfg.dev;
in
{
  options.homecfg.dev.enable = lib.mkEnableOption "Manage development tools with home-manager";

  config = lib.mkIf (cfg.enable) {
    home.packages = with pkgs; [
      gnumake
      gradle
      nodejs-16_x
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
      package = pkgs.openjdk17-bootstrap;
    };

    programs.go = {
      enable = true;
      package = pkgs.go_1_20;
      goPath = ".go";
    };

    # https://utcc.utoronto.ca/~cks/space/blog/programming/Go121ToolchainDownloads
    xdg.configFile = {
      "go/env".text = ''
        GOTOOLCHAIN=local
      '';
    };

    editorconfig = {
      enable = true;
      settings = {
        "*" = {
          charset = "utf-8";
          end_of_line = "lf";
          insert_final_newline = true;
          trim_trailing_whitespace = true;
          indent_size = 2;
          indent_style = "space";
        };
        "Makefile" = {
          indent_style = "tab";
          tab_width = 2;
        };
        "{*.go,go.mod}" = {
          indent_style = "tab";
          indent_size = 2;
        };
        "*.java" = {
          indent_style = "space";
          indent_size = 4;
        };
      };
    };
  };
}

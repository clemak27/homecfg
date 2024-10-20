{ config, lib, pkgs, ... }:
let
  cfg = config.homecfg.nvim;

  jdtlsSource = pkgs.stdenv.mkDerivation {
    name = "jdtls-source";
    version = "1.40.0";
    src = pkgs.fetchurl {
      url = "https://download.eclipse.org/jdtls/milestones/1.40.0/jdt-language-server-1.40.0-202409261450.tar.gz";
      hash = "sha256-dBb8Yr76RQ4y8G7CtQPy7sXyLwscwS97juURK/ZxzxE=";
    };
    unpackPhase = ":";
    nativeBuildInputs = [ ];
    installPhase = ''
      mkdir -p ./tmp
      tar xf "$src" --directory ./tmp
      cp -R "./tmp" "$out"
    '';
  };

  javaTest = pkgs.stdenv.mkDerivation {
    name = "vscode-java-test";
    version = "0.42.0";
    src = pkgs.fetchurl {
      # https://open-vsx.org/extension/vscjava/vscode-java-test
      url = "https://open-vsx.org/api/vscjava/vscode-java-test/0.42.0/file/vscjava.vscode-java-test-0.42.0.vsix";
      hash = "sha256-YpMWdTNZW4EtBJDF4rZJ+SC/YeszHxfeYEY2T+OJS+o=";
    };
    unpackPhase = ":";
    nativeBuildInputs = [ pkgs.unzip ];
    installPhase = ''
      cp "$src" "tmp.zip"
      mkdir -p ./tmp
      unzip "tmp.zip" -d ./tmp
      cp -R "./tmp/extension/server" "$out"
    '';
  };

  javaDebug = pkgs.stdenv.mkDerivation {
    name = "vscode-java-debug";
    version = "0.58.0";
    src = pkgs.fetchurl {
      # https://open-vsx.org/extension/vscjava/vscode-java-debug
      url = "https://open-vsx.org/api/vscjava/vscode-java-debug/0.58.0/file/vscjava.vscode-java-debug-0.58.0.vsix";
      hash = "sha256-Q3TE/nubd15Wj+6k19Gi+6nIUFbUQ24CxbBP6GAGRHE=";
    };
    unpackPhase = ":";
    nativeBuildInputs = [ pkgs.unzip ];
    installPhase = ''
      cp "$src" "tmp.zip"
      mkdir -p ./tmp
      unzip "tmp.zip" -d ./tmp
      cp -R "./tmp/extension/server" "$out"
    '';
  };

  springExtensions = pkgs.stdenv.mkDerivation {
    name = "vscode-spring-boot";
    version = "1.57.0";
    src = pkgs.fetchurl {
      # https://open-vsx.org/extension/VMware/vscode-spring-boot
      url = "https://open-vsx.org/api/VMware/vscode-spring-boot/1.57.0/file/VMware.vscode-spring-boot-1.57.0.vsix";
      hash = "sha256-6Lx8gF8v1E2U/wFtGyB+JyvnE9N1be6EN8UV5Rl1Do0=";
    };
    unpackPhase = ":";
    nativeBuildInputs = [ pkgs.unzip ];
    installPhase = ''
      cp "$src" "tmp.zip"
      mkdir -p ./tmp
      unzip "tmp.zip" -d ./tmp
      cp -R "./tmp/extension" "$out"
    '';
  };
in
{
  options.homecfg.nvim.enable = lib.mkEnableOption "Manage neovim with homecfg";
  options.homecfg.nvim.transparent = lib.mkEnableOption "Use a transparent background";

  config = lib.mkIf (cfg.enable) {

    programs.neovim = {
      enable = true;
      withNodeJs = true;
      vimAlias = true;
      vimdiffAlias = true;
      extraPackages = with pkgs; [
        cargo
        deno
        gcc
        nodejs-18_x
        python311
        yarn

        # html/css/json/eslint
        nodePackages.vscode-langservers-extracted

        # markdown
        marksman
        nodePackages.markdownlint-cli
        ltex-ls

        # container
        stable.hadolint

        # yaml
        nodePackages.yaml-language-server
        yamlfmt
        yamllint

        # shell
        nodePackages.bash-language-server
        shellcheck
        shfmt

        # nix
        nixd
        nixpkgs-fmt

        # lua
        lua-language-server
        stylua

        # go
        delve
        gofumpt
        golangci-lint
        golangci-lint-langserver
        (gopls.override { buildGoModule = pkgs.buildGo123Module; })
        gotools

        # java
        jdt-language-server

        # js
        biome
        nodePackages.prettier
        nodePackages.typescript-language-server
        vscode-js-debug
        vue-language-server

        # rust
        rust-analyzer

        # python
        python312Packages.black
        python312Packages.jedi-language-server

        # kotlin-language-server
        kotlin-language-server
      ];
    };

    home.file = {
      ".markdownlintrc".text = (builtins.toJSON
        {
          default = true;
          MD013 = {
            code_blocks = false;
          };
        }
      );

      ".jdtls/plugins".source = "${jdtlsSource}/plugins";
      ".jdtls/config_linux/config.ini".source = "${jdtlsSource}/config_linux/config.ini";
      ".jdtls/config_mac/config.ini".source = "${jdtlsSource}/config_mac/config.ini";
      ".jdtls/bundles/java-test".source = javaTest;
      ".jdtls/bundles/java-debug-adapter".source = javaDebug;
      ".jdtls/bundles/vscode-spring-boot".source = springExtensions;
    };

    programs.zsh = {
      sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        NVIM_TRANSPARENT = if cfg.transparent then "true" else "false";
      };
    };

    xdg.configFile = {
      "nvim/init.lua".source = ./init.lua;
      "nvim/lua".source = ./lua;

      "yamlfmt/.yamlfmt".text = ''
        formatter:
          type: basic
          include_document_start: true
          pad_line_comments: 2
          retain_line_breaks_single: true
      '';
    };
  };
}

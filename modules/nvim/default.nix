{ config, lib, pkgs, ... }:
let
  cfg = config.homecfg.nvim;

  jdtlsSource = let version = "1.43.0"; in pkgs.stdenv.mkDerivation {
    name = "jdtls-source";
    version = "${version}";
    src = pkgs.fetchurl {
      url = "https://download.eclipse.org/jdtls/milestones/${version}/jdt-language-server-${version}-202412191447.tar.gz";
      hash = "sha256-46M/+Iiq8dmY7AtuDx7LjurFPu+I3eIiBMPNM3nl+5g=";
    };
    unpackPhase = ":";
    nativeBuildInputs = [ ];
    installPhase = ''
      mkdir -p ./tmp
      tar xf "$src" --directory ./tmp
      cp -R "./tmp" "$out"
    '';
  };

  javaTest = let version = "0.43.0"; in pkgs.stdenv.mkDerivation {
    name = "vscode-java-test";
    version = "${version}";
    src = pkgs.fetchurl {
      # https://open-vsx.org/extension/vscjava/vscode-java-test
      url = "https://open-vsx.org/api/vscjava/vscode-java-test/${version}/file/vscjava.vscode-java-test-${version}.vsix";
      hash = "sha256-MPrGkKtqV728vbiNX1nXmGAWuv1ULKs4tKdryrvUBZI=";
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

  javaDebug = let version = "0.58.1"; in pkgs.stdenv.mkDerivation {
    name = "vscode-java-debug";
    version = "${version}";
    src = pkgs.fetchurl {
      # https://open-vsx.org/extension/vscjava/vscode-java-debug
      url = "https://open-vsx.org/api/vscjava/vscode-java-debug/${version}/file/vscjava.vscode-java-debug-${version}.vsix";
      hash = "sha256-0e31eigyGvyx2Iq4xSXx7E7e+DfM2c6P4scXnyxqdPc=";
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

  springExtensions = let version = "1.59.0"; in pkgs.stdenv.mkDerivation {
    name = "vscode-spring-boot";
    version = "${version}";
    src = pkgs.fetchurl {
      # https://open-vsx.org/extension/VMware/vscode-spring-boot
      url = "https://open-vsx.org/api/VMware/vscode-spring-boot/${version}/file/VMware.vscode-spring-boot-${version}.vsix";
      hash = "sha256-m1N1pOjyrWp+AQjijcRbAgkl3gUNw6iuK02wPgNa7MU=";
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
        nodejs_22
        python311
        yarn

        # html/css/json/eslint
        nodePackages.vscode-langservers-extracted

        # markdown
        nodePackages.markdownlint-cli
        ltex-ls

        # container
        hadolint

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

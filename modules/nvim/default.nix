{ config, lib, pkgs, ... }:
let
  cfg = config.homecfg.nvim;

  jdtlsSource = pkgs.stdenv.mkDerivation {
    name = "jdtls-source";
    version = "1.38.0";
    src = pkgs.fetchurl {
      url = "https://download.eclipse.org/jdtls/milestones/1.38.0/jdt-language-server-1.38.0-202408011337.tar.gz";
      hash = "sha256-uml3iKGfK6V7FjAqums0PGSZKMlfdrDRcElKwS0XrHg=";
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
    version = "0.41.1";
    src = pkgs.fetchurl {
      # https://open-vsx.org/extension/vscjava/vscode-java-test
      url = "https://open-vsx.org/api/vscjava/vscode-java-test/0.41.1/file/vscjava.vscode-java-test-0.41.1.vsix";
      hash = "sha256-iXIeTkyn1LNtG8Fs9pIw56dFgFfPZy5nQWRPxBHoZMI=";
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
      ".vsnip".source = ./vsnip;

      ".jdtls/plugins".source = "${jdtlsSource}/plugins";
      ".jdtls/config_linux/config.ini".source = "${jdtlsSource}/config_linux/config.ini";
      ".jdtls/config_mac/config.ini".source = "${jdtlsSource}/config_mac/config.ini";
      ".jdtls/formatter.xml".source = ./jdtls-fmt.xml;
      ".jdtls/bundles/java-test".source = javaTest;
      ".jdtls/bundles/java-debug-adapter".source = javaDebug;
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
      "nvim/ftplugin".source = ./ftplugin;

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

{ config, lib, pkgs, ... }:
let
  cfg = config.homecfg;
  hxPkg = cfg.helix.package;
  goimports = pkgs.buildGoModule rec {
    pname = "goimports";
    version = "0.12.2";

    src = pkgs.fetchFromGitHub {
      owner = "golang";
      repo = "tools";
      rev = "gopls/v${version}";
      sha256 = "sha256-mbJ9CzJxhAxYByfNpNux/zOWBGaiH4fvIRIh+BMprMk=";
    };

    vendorSha256 = "sha256-W5t1ZLI4zBocAtxfB8zXfxx2asgUXrMi9YOfkWcOxmM=";

    doCheck = false;

    subPackages = [ "cmd/goimports" ];
  };

  # https://github.com/arnarg/config/blob/0309e47240ea652b01557289b0d43ee6d2654a2c/home/development/helix/default.nix#L6-L40
  # Extra packages that should be added to PATH in helix
  extraPaths = [

    # lsp
    pkgs.efm-langserver
    pkgs.ltex-ls
    pkgs.nil
    pkgs.nodePackages.bash-language-server
    pkgs.nodePackages.vscode-langservers-extracted
    pkgs.nodePackages.yaml-language-server
    pkgs.stylua
    pkgs.sumneko-lua-language-server

    # linter
    pkgs.hadolint
    pkgs.nodePackages.markdownlint-cli
    pkgs.shellcheck
    pkgs.yamllint

    # formatter
    pkgs.nixpkgs-fmt
    pkgs.nodePackages.prettier
    pkgs.shfmt
    pkgs.yamlfmt

    # go
    pkgs.delve
    pkgs.golangci-lint
    pkgs.gopls
    pkgs.gofumpt
    goimports
  ];

  # Wrap helix to add packages above in PATH
  wrappedHelix = pkgs.symlinkJoin {
    name = "helix-wrapped-${lib.getVersion hxPkg }";
    paths = [ hxPkg ];
    preferLocalBuild = true;
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      rm $out/bin/hx
      makeWrapper "${hxPkg}/bin/hx" $out/bin/hx \
        --prefix PATH : ${lib.makeBinPath extraPaths}
    '';
  };
in
{
  options.homecfg.helix = {
    enable = lib.mkEnableOption "Manage helix with home-manager";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.helix;
      # description = "The package of helix to use.";
    };
  };

  config = lib.mkIf (cfg.helix.enable) {

    home.packages = [
      wrappedHelix
    ];

    xdg.configFile = {
      "helix/config.toml".source = config.lib.file.mkOutOfStoreSymlink "/home/clemens/Projects/homecfg/modules/helix/config.toml";
      "helix/languages.toml".source = config.lib.file.mkOutOfStoreSymlink "/home/clemens/Projects/homecfg/modules/helix/languages.toml";

      "yamlfmt/.yamlfmt".text = ''
        formatter:
          type: basic
          include_document_start: true
      '';
    };
  };
}

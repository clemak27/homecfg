{ config, lib, pkgs, ... }:
let
  cfg = config.homecfg.nvim;
  defaultMarkdownlintRc = {
    "default" = true;
    "MD013" = {
      "code_blocks" = false;
    };
  };
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
  # jdtlsFormat = ''
  #   <?xml version="1.0" encoding="UTF-8" standalone="no"?>
  #   <profiles version="13">
  #     <profile kind="CodeFormatterProfile" name="custom" version="13">
  #       <setting id="org.eclipse.jdt.core.formatter.align_assignment_statements_on_columns" value="true"/>
  #       <setting id="org.eclipse.jdt.core.formatter.align_type_members_on_columns" value="true"/>
  #       <setting id="org.eclipse.jdt.core.formatter.align_variable_declarations_on_columns" value="true"/>
  #       <setting id="org.eclipse.jdt.core.formatter.join_wrapped_lines" value="true"/>
  #       <setting id="org.eclipse.jdt.core.formatter.lineSplit" value="200"/>
  #       <setting id="org.eclipse.jdt.core.formatter.tabulation.char" value="space"/>
  #     </profile>
  #   </profiles>
  # '';
in
{
  options.homecfg.nvim.enable = lib.mkEnableOption "Manage neovim with homecfg";

  config = lib.mkIf (cfg.enable) {

    programs.neovim = {
      enable = true;
      withNodeJs = true;
      vimAlias = true;
      vimdiffAlias = true;
      extraPackages = with pkgs; [
        cargo
        gcc
        nodejs-16_x
        python311
        yarn

        # lsp
        efm-langserver
        ltex-ls
        nil
        nodePackages.bash-language-server
        nodePackages.vscode-langservers-extracted
        nodePackages.yaml-language-server
        stylua
        sumneko-lua-language-server

        # linter
        hadolint
        nodePackages.markdownlint-cli
        shellcheck
        yamllint

        # formatter
        nixpkgs-fmt
        nodePackages.prettier
        shfmt
        yamlfmt

        # go
        delve
        golangci-lint
        gopls
        gofumpt
        goimports
      ];
    };

    home.file = {
      ".markdownlintrc".text = (builtins.toJSON defaultMarkdownlintRc);
      # ".jdtls-fmt.xml".text = jdtlsFormat;
      ".vsnip".source = ./vsnip;
    };

    # programs.zsh = {
    #   sessionVariables = {
    #     EDITOR = "nvim";
    #     VISUAL = "nvim";
    #   };
    # };

    xdg.configFile = {
      "nvim/init.lua".source = ./init.lua;
      "nvim/lua".source = ./lua;
      "nvim/ftplugin".source = ./ftplugin;

      "yamlfmt/.yamlfmt".text = ''
        formatter:
          type: basic
          include_document_start: true
      '';
    };
  };
}

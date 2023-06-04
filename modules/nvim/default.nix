{ config, lib, pkgs, ... }:
let
  cfg = config.homecfg.nvim;
  defaultMarkdownlintRc = {
    "default" = true;
    "MD013" = {
      "code_blocks" = false;
    };
  };
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
      ];
    };

    home.file = {
      ".markdownlintrc".text = (builtins.toJSON defaultMarkdownlintRc);
      ".vsnip".source = ./vsnip;
    };
    xdg.configFile = {
      "nvim/init.lua".source = ./init.lua;
      "nvim/lua".source = ./lua;
      "nvim/ftplugin".source = ./ftplugin;
    };
  };
}

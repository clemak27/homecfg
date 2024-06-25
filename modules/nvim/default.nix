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
        nil
      ];
    };

    home.file = {
      ".markdownlintrc".text = (builtins.toJSON defaultMarkdownlintRc);
      ".jdtls-fmt.xml".source = ./jdtls-fmt.xml;
      ".vsnip".source = ./vsnip;
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

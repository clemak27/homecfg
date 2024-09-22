{ config, lib, pkgs, ... }:
let
  cfg = config.homecfg.tools;
in
{
  options.homecfg.tools.enable = lib.mkEnableOption "Manage command line tools with homecfg";

  config = lib.mkIf (cfg.enable) {
    home.packages = with pkgs; [
      bat
      bat-extras.batman
      btop
      curl
      eza
      fd
      gojq
      hurl
      hyperfine
      jo
      libqalculate
      pgcli
      ripgrep
      sd
      tealdeer
      tree
      unzip
      viddy
      yazi
      yq-go
    ] ++ lib.optionals stdenv.isLinux [
      android-tools
    ];

    programs.fzf = {
      enable = true;
      defaultCommand = "rg --files --hidden";
      defaultOptions = [
        "--height=99%"
        "--layout=reverse"
        "--info=inline"
        "--border=sharp"
        "--margin=2"
        "--padding=1"
        "--color=bg+:#313244,spinner:#f5e0dc,hl:#f38ba8"
        "--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc"
        "--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
      ];
    };

    programs.zsh.oh-my-zsh.plugins = [
      "fzf"
    ];

    programs.zsh.shellAliases = builtins.listToAttrs (
      [
        { name = "cat"; value = "bat"; }
        { name = "ls"; value = "eza --icons"; }
        { name = "lsa"; value = "eza --icons -hal"; }
        { name = "man"; value = "batman"; }
        { name = "watch"; value = "viddy"; }
      ]
    );

    home.file = {
      ".config/tealdeer/config.toml".source = ./tealdeer.toml;
      ".local/bin/rfv".source = ./rfv;
      ".local/bin/jq".source = "${pkgs.gojq}/bin/gojq";
      ".config/btop/btop.conf".source = ./btop.conf;
    };

    xdg.configFile = {
      "bat/config".source = ./bat/config;
    };
  };
}

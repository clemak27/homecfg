{ config, lib, pkgs, ... }:
let
  cfg = config.homecfg.tools;
  todoDue = pkgs.writeShellScript "todo-due" ''
    todo.sh ls | rg -q due:$(date -I) -
    if [ $? -eq 0 ]; then
      echo "Tasks due today:"
      todo.sh ls | rg --color=never due:$(date -I) -
    fi
  '';
in
{
  options.homecfg.tools.enable = lib.mkEnableOption "Manage command line tools with homecfg";

  config = lib.mkIf (cfg.enable) {
    home.packages = with pkgs; [
      bat
      bat-extras.batman
      btop
      curl
      exa
      fd
      gojq
      hyperfine
      jo
      libqalculate
      pgcli
      ranger
      ripgrep
      sd
      tealdeer
      timewarrior
      todo-txt-cli
      tree
      unzip
      viddy
      yq-go
    ] ++ lib.optionals stdenv.isLinux [
      android-tools
    ];

    home.file.".oh-my-zsh/custom/plugins/timewarrior".source =
      builtins.fetchGit {
        url = "https://github.com/svenXY/timewarrior.git";
        ref = "master";
        rev = "083d40edfa0b0a64d84a23ee370097beb43d4dd8";
      };

    home.file.".config/ranger/plugins/ranger_devicons".source =
      builtins.fetchGit {
        url = "https://github.com/alexanderjeurissen/ranger_devicons.git";
        ref = "main";
        rev = "49fe4753c89615a32f14b2f4c78bbd02ee76be3c";
      };

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
        "--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8"
        "--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc"
        "--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
      ];
    };

    programs.zsh.oh-my-zsh.plugins = [
      "fd"
      "fzf"
      "ripgrep"
      "timewarrior"
    ];

    programs.zsh.shellAliases = builtins.listToAttrs (
      [
        { name = "cat"; value = "bat"; }
        { name = "ls"; value = "exa --icons"; }
        { name = "lsa"; value = "exa --icons -hal"; }
        { name = "man"; value = "batman"; }
        { name = "todo"; value = "todo.sh"; }
        { name = "watch"; value = "viddy"; }
      ]
    );

    home.file = {
      ".todo/config".source = ./todo/todo.cfg;
      ".todo.actions.d/due".source = "${todoDue}";
      ".config/tealdeer/config.toml".source = ./tealdeer.toml;
      ".local/bin/rfv".source = ./rfv;
      ".local/bin/jq".source = "${pkgs.gojq}/bin/gojq";
      ".config/btop/btop.conf".source = ./btop.conf;
    };

    xdg.configFile = {
      "ranger/rc.conf".source = ./ranger/ranger.rc;
      "ranger/commands.py".source = ./ranger/ranger.commands;
      "bat/config".source = ./bat/config;
    };
  };
}

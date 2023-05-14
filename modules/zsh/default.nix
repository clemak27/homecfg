{ config, lib, pkgs, ... }:
let
  cfg = config.homecfg.zsh;
  inSecureDirs = if pkgs.stdenv.isDarwin then "true" else "false";
in
{
  imports = [
    ./starship.nix
    ./direnv.nix
  ];

  options.homecfg.zsh.enable = lib.mkEnableOption "Manage zsh with home-manager";

  config = lib.mkIf (cfg.enable) {
    programs.zsh = {
      enable = true;
      localVariables = {
        # https://unix.stackexchange.com/questions/167582/why-zsh-ends-a-line-with-a-highlighted-percent-symbol
        PROMPT_EOL_MARK = "";
        ZSH_DISABLE_COMPFIX = inSecureDirs;
      };
      history = {
        size = 50000;
        save = 25000;
      };
      oh-my-zsh = {
        enable = true;
        plugins = [
          "extract"
          "rsync"
        ];
        custom = "$HOME/.oh-my-zsh/custom";
      };
      shellAliases = builtins.listToAttrs (
        [
          { name = "cd.."; value = "cd .."; }
          { name = "clear"; value = "[[ -e /usr/bin/clear ]] && /usr/bin/clear || printf '\\33c\\e[3J'; [[ -n $TMUX ]] && tmux clearhist;"; }
          { name = "q"; value = "exit"; }
        ]
      );

      sessionVariables = {
        BROWSER = "firefox";
        EDITOR = "nvim";
        PATH = "$PATH:$HOME/.cargo/bin:$HOME/.go/bin:$HOME/.local/bin:$HOME/.local/bin/npm/bin";
        VISUAL = "nvim";
      };

      initExtra = builtins.concatStringsSep "\n" (
        [
          # no beeps
          "unsetopt beep"
          # don't save duplicates in zsh_history
          "setopt HIST_SAVE_NO_DUPS"
          # custom functions
          "for file in ~/.zsh_functions/*; do . $file; done"
          # https://github.com/zsh-users/zsh-syntax-highlighting#why-must-zsh-syntax-highlightingzsh-be-sourced-at-the-end-of-the-zshrc-file
          "source $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
        ]
      );
    };

    home.file.".oh-my-zsh/custom/plugins/zsh-syntax-highlighting".source =
      builtins.fetchGit {
        url = "https://github.com/zsh-users/zsh-syntax-highlighting.git";
        ref = "master";
        rev = "b2c910a85ed84cb7e5108e7cb3406a2e825a858f";
      };

    programs.dircolors.enable = true;

    home.packages = with pkgs; [
      zsh-completions
    ];


    home.file = {
      ".zsh_functions" = {
        source = ./zsh_functions;
        recursive = true;
      };
    };
  };
}

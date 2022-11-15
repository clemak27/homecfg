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
          { name = "clear"; value = "if [ -n $TMUX ]; then /usr/bin/clear && tmux clearhist; else printf '\\33c\\e[3J'; fi"; }
          { name = "q"; value = "exit"; }
        ]
      );

      sessionVariables = {
        BROWSER = "firefox";
        DIRENV_LOG_FORMAT = "";
        EDITOR = "nvim";
        PATH = "$PATH:$HOME/.cargo/bin:$HOME/.go/bin:$HOME/.local/bin:$HOME/.local/bin/npm/bin";
        VISUAL = "nvim";
      };

      initExtra = builtins.concatStringsSep "\n" (
        [ ]
        # tea autocomplete
        ++ lib.optionals config.homecfg.git.tea [
          "PROG=tea _CLI_ZSH_AUTOCOMPLETE_HACK=1 source $HOME/.config/tea/autocomplete.zsh"
        ]
        ++ lib.optionals config.homecfg.git.glab [
          "eval \"$(glab completion -s zsh)\""
        ]
        ++ [
          # no beeps
          "unsetopt beep"
          # don't save duplicates in zsh_history
          "setopt HIST_SAVE_NO_DUPS"
          # custom functions
          "for file in ~/.zsh_functions/*; do . $file; done"
          # local additional zsh file
          "[[ ! -f ~/.local.zsh ]] || source ~/.local.zsh"
          # https://github.com/zsh-users/zsh-syntax-highlighting#why-must-zsh-syntax-highlightingzsh-be-sourced-at-the-end-of-the-zshrc-file
          "source $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
        ]
      );
    };

    home.file.".oh-my-zsh/custom/plugins/zsh-syntax-highlighting".source =
      builtins.fetchGit {
        url = "https://github.com/zsh-users/zsh-syntax-highlighting.git";
        ref = "master";
        rev = "122dc464392302114556b53ec01a1390c54f739f";
      };

    programs.dircolors.enable = true;

    home.file = {
      ".zsh_functions".source = ./zsh_functions;
    };
  };
}

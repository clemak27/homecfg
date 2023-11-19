{ pkgs, config, lib, ... }:
let
  cfg = config.homecfg.tasks;
  todoDue = pkgs.writeShellScript "todo-due" ''
    todo.sh ls | rg -q due:$(date -I) -
    if [ $? -eq 0 ]; then
      echo "Tasks due today:"
      todo.sh ls | rg --color=never due:$(date -I) -
    fi
  '';
  todoAgain = builtins.fetchGit {
    url = "https://github.com/nthorne/todo.txt-cli-again-addon.git";
    ref = "master";
    rev = "0c29ac97018d0cd43f8f30006d8bc766b2173e86";
  };
in
{
  options.homecfg.tasks.enable = lib.mkEnableOption "Manage tasks with home-manager";

  config = lib.mkIf (cfg.enable) {

    xdg.configFile."task/taskrc".text = ''
      data.location=~/.local/share/task
      hooks.location=~/.config/task/hooks
    '';

    xdg.configFile."task/hooks/on-modify.timewarrior" = {
      source = "${pkgs.timewarrior}/share/doc/timew/ext/on-modify.timewarrior";
      executable = true;
    };

    home.packages = with pkgs; [
      taskwarrior
      taskwarrior-tui
      timewarrior
      todo-txt-cli
    ];

    home.file.".oh-my-zsh/custom/plugins/timewarrior".source =
      builtins.fetchGit {
        url = "https://github.com/svenXY/timewarrior.git";
        ref = "master";
        rev = "083d40edfa0b0a64d84a23ee370097beb43d4dd8";
      };

    programs.zsh = {
      oh-my-zsh.plugins = [
        "taskwarrior"
        "timewarrior"
      ];

      shellAliases = builtins.listToAttrs (
        [
          { name = "todo"; value = "todo.sh"; }
        ]
      );
    };

    home.file = {
      ".todo/config".source = ./todo.cfg;
      ".todo.actions.d/due".source = "${todoDue}";
      ".todo.actions.d/again".source = "${todoAgain}/again";
    };
  };
}

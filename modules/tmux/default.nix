{ config, lib, pkgs, ... }:
let
  cfg = config.homecfg.tmux;
  colors = config.homecfg.colors;
in
{
  options.homecfg.tmux.enable = lib.mkEnableOption "Manage tmux with home-manager";

  config = lib.mkIf (cfg.enable) {

    programs.tmux = {
      enable = true;
      sensibleOnTop = false;
      baseIndex = 1;
      escapeTime = 0;
      historyLimit = 50000;
      terminal = "xterm-256color";
      prefix = "C-y";
      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.resurrect;
        }
        # TODO autosave does not work, it gets loaded before extraConfig which means status-right get overridden
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '15' # minutes
          '';
        }
      ];
      extraConfig = ''
        set-window-option -g xterm-keys on
        setw -g mode-keys vi

        bind-key y send-prefix

        set -g default-terminal "xterm-256color"
        set-option -ga terminal-overrides ",xterm-256color:Tc"
        set-option -g -w automatic-rename on
        set-option -g renumber-windows on
        set-option -g bell-action none

        bind-key o split-window -v -c "#{pane_current_path}"
        bind-key O split-window -h -c "#{pane_current_path}"
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R
        bind t if-shell -F '#{==:#{session_name},floating}' { detach-client } { popup -E -w 90% -h 90% 'tmux attach -t floating || tmux new -s floating -c "#{pane_current_path}"' }
        if -F "#{==:#{session_name},floating}" "set -g status off" "set -g status on"
        set-hook -g window-linked 'if -F "#{==:#{session_name},floating}" "set status off" "set status on"'
        set-hook -g window-unlinked 'if -F "#{==:#{session_name},floating}" "set status off" "set status on"'
        bind -n M-, swap-pane -U
        bind -n M-. swap-pane -D
        bind -n M-h previous-window
        bind -n M-l next-window

        # Enter copy mode
        bind-key -n M-v copy-mode

        # Select
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi V send-keys -X select-line
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle

        # Copy
        bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel ${if pkgs.stdenv.isLinux then "\"xclip -i -sel clip > /dev/null\"" else "\"pbcopy\""}
        bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel ${if pkgs.stdenv.isLinux then "\"xclip -in -selection clipboard\"" else "\"pbcopy\""}

        # Cancel
        bind-key -T copy-mode-vi Escape send-keys -X cancel

        # Paste
        bind-key p paste-buffer -s ""
        bind-key P choose-buffer "paste-buffer -b '%%' -s '''"

        # enable mouse
        set -g mouse on

        # Make mouse drag end behavior configurable
        unbind-key -T copy-mode-vi MouseDragEnd1Pane
        bind-key -T copy-mode-vi WheelUpPane select-pane \; send-keys -t '{mouse}' -X clear-selection \; send-keys -t '{mouse}' -X -N 3 scroll-up
        bind-key -T copy-mode-vi WheelDownPane select-pane \; send-keys -t '{mouse}' -X clear-selection \; send-keys -t '{mouse}' -X -N 3 scroll-down

        # Jump search mode with prefix
        bind-key '/' copy-mode \; send-keys "/"
        bind-key '?' copy-mode \; send-keys "?"

        # theme

        # --> Catppuccin (Mocha)
        thm_bg="#1e1e2e"
        thm_fg="#cdd6f4"
        thm_cyan="#89dceb"
        thm_black="#181825"
        thm_gray="#313244"
        thm_magenta="#cba6f7"
        thm_pink="#f5c2e7"
        thm_red="#f38ba8"
        thm_green="#a6e3a1"
        thm_yellow="#f9e2af"
        thm_blue="#89b4fa"
        thm_orange="#fab387"
        thm_black4="#585b70"

        set -g mode-style "fg=$thm_fg,bg=$thm_black4"

        set -g message-style "fg=$thm_fg,bg=$thm_black"
        set -g message-command-style "fg=$thm_fg,bg=$thm_black"

        set -g pane-border-style "fg=$thm_black4"
        set -g pane-active-border-style "fg=$thm_black4"

        set -g status on
        set -g status-interval 5
        set -g status-position top
        set -g status-justify "left"

        set -g status-style "fg=$thm_blue,bg=#11111b"

        set -g status-left-length "100"
        set -g status-right-length "100"

        set -g status-left-style NONE
        set -g status-right-style NONE

        set -g status-left "#[fg=$thm_blue,bg=$thm_gray] #S "
        set -g status-right ""

        setw -g window-status-activity-style "underscore,fg=$thm_fg,bg=$thm_black"
        setw -g window-status-separator ""
        setw -g window-status-style "NONE,fg=$thm_fg,bg=#11111b"
        setw -g window-status-format " #I: #W#F "
        setw -g window-status-current-format "#[fg=$thm_fg,bg=$thm_bg,bold] #I: #W#F "
      '';
    };


    programs.zsh.shellAliases = builtins.listToAttrs (
      [
        { name = "trwp"; value = "tmux rename-window '#{b:pane_current_path}'"; }
        { name = "tfp"; value = ''tmux if-shell -F '#{==:#{session_name},floating}' { detach-client } { popup -E -w 90% -h 90% 'tmux attach -t floating || tmux new -s floating -c "#{pane_current_path}"' }''; }

      ]
    );
  };
}

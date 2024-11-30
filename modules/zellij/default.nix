{ pkgs, config, lib, ... }:
let
  cfg = config.homecfg;
in
{
  options.homecfg.zellij = {
    enable = lib.mkEnableOption "Manage zellij with home-manager";

    zjstatusOptions = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Settings for zjStatus";
      example = '' {
            k8s_enable  true
        }
      '';
    };
  };

  config = lib.mkIf (cfg.zellij.enable) {

    programs.zellij = {
      enable = true;
    };

    xdg.configFile = {
      "zellij/config.kdl".text = ''
        plugins {
            tab-bar { path "tab-bar"; }
            status-bar { path "status-bar"; }
            strider { path "strider"; }
            compact-bar { path "compact-bar"; }
        }

        theme "catppuccin-mocha"

        default_layout "custom"
        scroll_buffer_size 20000

        // layout_dir "$HOME/.config/zellij/layouts"

        ui {
            pane_frames {
                hide_session_name true
            }
        }

        keybinds clear-defaults=true {
            normal {
            }
            locked {
                bind "Ctrl g" { SwitchToMode "Normal"; }
            }
            resize {
                bind "Ctrl n" { SwitchToMode "Normal"; }
                bind "h" "Left" { Resize "Increase Left"; }
                bind "j" "Down" { Resize "Increase Down"; }
                bind "k" "Up" { Resize "Increase Up"; }
                bind "l" "Right" { Resize "Increase Right"; }
                bind "H" { Resize "Decrease Left"; }
                bind "J" { Resize "Decrease Down"; }
                bind "K" { Resize "Decrease Up"; }
                bind "L" { Resize "Decrease Right"; }
                bind "=" "+" { Resize "Increase"; }
                bind "-" { Resize "Decrease"; }
            }
            pane {
                bind "Ctrl p" { SwitchToMode "Normal"; }
                bind "h" "Left" { MoveFocus "Left"; }
                bind "l" "Right" { MoveFocus "Right"; }
                bind "j" "Down" { MoveFocus "Down"; }
                bind "k" "Up" { MoveFocus "Up"; }
                bind "p" { SwitchFocus; }
                bind "n" { NewPane; SwitchToMode "Normal"; }
                bind "d" { NewPane "Down"; SwitchToMode "Normal"; }
                bind "r" { NewPane "Right"; SwitchToMode "Normal"; }
                bind "x" { CloseFocus; SwitchToMode "Normal"; }
                bind "f" { ToggleFocusFullscreen; SwitchToMode "Normal"; }
                bind "z" { TogglePaneFrames; SwitchToMode "Normal"; }
                bind "w" { ToggleFloatingPanes; SwitchToMode "Normal"; }
                bind "e" { TogglePaneEmbedOrFloating; SwitchToMode "Normal"; }
                bind "c" { Clear; SwitchToMode "Normal"; }
            }
            move {
                bind "Ctrl m" { SwitchToMode "Normal"; }
                bind "n" "Tab" { MovePane; }
                bind "p" { MovePaneBackwards; }
                bind "h" "Left" { MovePane "Left"; }
                bind "j" "Down" { MovePane "Down"; }
                bind "k" "Up" { MovePane "Up"; }
                bind "l" "Right" { MovePane "Right"; }
            }
            tab {
                bind "Ctrl t" { SwitchToMode "Normal"; }
                bind "r" { SwitchToMode "RenameTab"; TabNameInput 0; }
                bind "h" "Left" "Up" "k" { GoToPreviousTab; }
                bind "l" "Right" "Down" "j" { GoToNextTab; }
                bind "n" { NewTab; SwitchToMode "Normal"; }
                bind "x" { CloseTab; SwitchToMode "Normal"; }
                bind "s" { ToggleActiveSyncTab; SwitchToMode "Normal"; }
                bind "1" { GoToTab 1; SwitchToMode "Normal"; }
                bind "2" { GoToTab 2; SwitchToMode "Normal"; }
                bind "3" { GoToTab 3; SwitchToMode "Normal"; }
                bind "4" { GoToTab 4; SwitchToMode "Normal"; }
                bind "5" { GoToTab 5; SwitchToMode "Normal"; }
                bind "6" { GoToTab 6; SwitchToMode "Normal"; }
                bind "7" { GoToTab 7; SwitchToMode "Normal"; }
                bind "8" { GoToTab 8; SwitchToMode "Normal"; }
                bind "9" { GoToTab 9; SwitchToMode "Normal"; }
                bind "Tab" { ToggleTab; }
            }
            scroll {
                bind "Ctrl s" { SwitchToMode "Normal"; }
                bind "e" { EditScrollback; SwitchToMode "Normal"; }
                bind "s" { SwitchToMode "EnterSearch"; SearchInput 0; }
                bind "Ctrl c" { ScrollToBottom; SwitchToMode "Normal"; }
                bind "j" "Down" { ScrollDown; }
                bind "k" "Up" { ScrollUp; }
                bind "Ctrl f" "PageDown" "Right" "l" { PageScrollDown; }
                bind "Ctrl b" "PageUp" "Left" "h" { PageScrollUp; }
                bind "d" { HalfPageScrollDown; }
                bind "u" { HalfPageScrollUp; }
                bind "c" { Clear; }
                // uncomment this and adjust key if using copy_on_select=false
                // bind "Alt c" { Copy; }
            }
            search {
                bind "Ctrl s" { SwitchToMode "Normal"; }
                bind "Ctrl c" { ScrollToBottom; SwitchToMode "Normal"; }
                bind "j" "Down" { ScrollDown; }
                bind "k" "Up" { ScrollUp; }
                bind "Ctrl f" "PageDown" "Right" "l" { PageScrollDown; }
                bind "Ctrl b" "PageUp" "Left" "h" { PageScrollUp; }
                bind "d" { HalfPageScrollDown; }
                bind "u" { HalfPageScrollUp; }
                bind "n" { Search "down"; }
                bind "p" { Search "up"; }
                bind "c" { SearchToggleOption "CaseSensitivity"; }
                bind "w" { SearchToggleOption "Wrap"; }
                bind "o" { SearchToggleOption "WholeWord"; }
            }
            entersearch {
                bind "Ctrl c" "Esc" { SwitchToMode "Scroll"; }
                bind "Enter" { SwitchToMode "Search"; }
            }
            renametab {
                bind "Ctrl c" { SwitchToMode "Normal"; }
                bind "Esc" { UndoRenameTab; SwitchToMode "Tab"; }
            }
            renamepane {
                bind "Ctrl c" { SwitchToMode "Normal"; }
                bind "Esc" { UndoRenamePane; SwitchToMode "Pane"; }
            }
            session {
                bind "Ctrl o" { SwitchToMode "Normal"; }
                bind "Ctrl s" { SwitchToMode "Scroll"; }
                bind "d" { Detach; }
            }
            tmux {
            }
            shared_except "locked" {
                bind "Ctrl g" { SwitchToMode "Locked"; }
                // bind "Ctrl q" { Quit; }
                bind "Alt n" { NewPane; }
                bind "Alt h" "Alt Left" { MoveFocusOrTab "Left"; }
                bind "Alt l" "Alt Right" { MoveFocusOrTab "Right"; }
                bind "Alt j" "Alt Down" { MoveFocus "Down"; }
                bind "Alt k" "Alt Up" { MoveFocus "Up"; }
                bind "Alt =" "Alt +" { Resize "Increase"; }
                bind "Alt -" { Resize "Decrease"; }
                bind "Alt [" { PreviousSwapLayout; }
                bind "Alt ]" { NextSwapLayout; }
            }
            shared_except "normal" "locked" {
                bind "Enter" "Esc" { SwitchToMode "Normal"; }
            }
            shared_except "pane" "locked" {
                bind "Ctrl p" { SwitchToMode "Pane"; }
            }
            shared_except "resize" "locked" {
                bind "Ctrl n" { SwitchToMode "Resize"; }
            }
            shared_except "scroll" "locked" {
                bind "Ctrl s" { SwitchToMode "Scroll"; }
            }
            shared_except "session" "locked" {
                bind "Ctrl o" { SwitchToMode "Session"; }
            }
            shared_except "tab" "locked" {
                bind "Ctrl t" { SwitchToMode "Tab"; }
            }
            shared_except "move" "locked" {
                bind "Ctrl q" { SwitchToMode "Move"; }
            }
        }
      '';

      "zellij/layouts/custom.kdl".text = ''
        layout {
          pane size=1 borderless=true {
              plugin location="file:${pkgs.zjstatus}/bin/zjstatus.wasm" ${cfg.zellij.zjstatusOptions}
          }
          pane {
            borderless true
          }
        }
      '';
    };
  };
}

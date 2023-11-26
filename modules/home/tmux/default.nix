{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.ironman) mkBoolOpt mkOpt;
  inherit (lib.types) int lines str;
  inherit (pkgs.tmuxPlugins) catppuccin-tmux sensible tmux-session-wizard yank;

  cfg = config.ironman.home.tmux;
in {
  options.ironman.home.tmux = {
    enable = mkBoolOpt true "Setup tmux";
    baseIndex = mkOpt int 1 "Base number for windows";
    clock24 = mkBoolOpt true "Use a 24 hour clock";
    extraConfig = mkOpt lines "" "Extra configuration options";
    historyLimit =
      mkOpt int 10000 "The number of lines to keep in scrollback history";
    keyMode = mkOpt str "vi" "Key style used for control";
    secureSocket = mkBoolOpt false "Use a secure socket to connect.";
    shortcut =
      mkOpt str "Space" "Default leader key that will be paired with <Ctrl>";
  };

  config = mkIf cfg.enable {
    ironman.home.tmux = {
      extraConfig = ''
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
        set-option -sa terminal-features ',xterm-kitty:RGB'
        set-option -g detach-on-destroy off
      '';
    };
    home.packages = with pkgs.ironman; [ t ];
    programs.tmux = {
      inherit (cfg)
        baseIndex clock24 extraConfig historyLimit keyMode secureSocket
        shortcut;
      enable = true;
      plugins = [
        {
          plugin = catppuccin-tmux;
          extraConfig = ''
            set -g @catppuccin_window_left_separator ""
            set -g @catppuccin_window_right_separator " "
            set -g @catppuccin_window_middle_separator " █"
            set -g @catppuccin_window_number_position "right"

            set -g @catppuccin_window_default_fill "number"
            set -g @catppuccin_window_default_text "#W"

            set -g @catppuccin_window_current_fill "number"
            set -g @catppuccin_window_current_text "#W"

            set -g @catppuccin_status_modules_right "directory user host session"
            set -g @catppuccin_status_left_separator  " "
            set -g @catppuccin_status_right_separator ""
            set -g @catppuccin_status_right_separator_inverse "no"
            set -g @catppuccin_status_fill "icon"
            set -g @catppuccin_status_connect_separator "no"

            set -g @catppuccin_directory_text "#{pane_current_path}"
          '';
        }
        sensible
        yank
        tmux-session-wizard
      ];
    };
  };
}

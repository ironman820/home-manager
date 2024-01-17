{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.ironman) mkBoolOpt mkOpt;
  inherit (lib.types) int lines str;

  cfg = config.ironman.home.tmux;
in {
  options.ironman.home.tmux = {
    enable = mkBoolOpt true "Setup tmux";
    baseIndex = mkOpt int 1 "Base number for windows";
    clock24 = mkBoolOpt true "Use a 24 hour clock";
    customPaneNavigationAndResize = mkBoolOpt true "Use hjkl for navigation";
    escapeTime = mkOpt int 0 "Escape time";
    extraConfig = mkOpt lines "" "Extra configuration options";
    historyLimit =
      mkOpt int 1000000 "The number of lines to keep in scrollback history";
    keyMode = mkOpt str "vi" "Key style used for control";
    secureSocket = mkBoolOpt false "Use a secure socket to connect.";
    shortcut =
      mkOpt str "Space" "Default leader key that will be paired with <Ctrl>";
    terminal = mkOpt str "screen-256color" "Default terminal config";
  };

  config = mkIf cfg.enable {
    ironman.home.tmux = {
      extraConfig = ''
        source-file ~/.config/tmux/tmux.reset.conf
        set-option -g terminal-overrides ',xterm-256color:RGB'

        set -g detach-on-destroy off
        set -g renumber-windows on
        set -g set-clipboard on
        set -g status-position top
        # set -g pane-border-status on

        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
        set-option -sa terminal-features ',xterm-kitty:RGB'
      '';
    };
    home.packages = with pkgs.ironman; [t];
    programs = {
      bash.bashrcExtra = ''
        if [[ -z "$TMUX" ]]; then
            ${pkgs.ironman.t}/bin/t $PWD
        fi
      '';
      tmux = {
        inherit
          (cfg)
          baseIndex
          clock24
          customPaneNavigationAndResize
          escapeTime
          extraConfig
          historyLimit
          keyMode
          secureSocket
          shortcut
          terminal
          ;
        enable = true;
        plugins = with pkgs.tmuxPlugins; [
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
          cheat-sh
          {
            plugin = continuum;
            extraConfig = ''
              set -g @continuum-restore 'on'
            '';
          }
          {
            plugin = resurrect;
            extraConfig = ''
              set -g @resurrect-strategy-nvim 'session'
            '';
          }
          sensible
          yank
          {
            plugin = tmux-fzf-url;
            extraConfig = ''
              set -g @fzf-url-fzf-options '-p 60%,30% --prompt="   " --border-label=" Open URL "'
              set -g @fzf-url-history-limit '2000'
            '';
          }
          tmux-session-wizard
        ];
      };
    };
    xdg.configFile."tmux/tmux.reset.conf".text = ''
      # First remove *all* keybindings
      # unbind-key -a
      # Now reinsert all the regular tmux keys
      # bind ^X lock-server
      bind C-c new-window
      bind C-d detach
      # bind * list-clients

      bind H previous-window
      bind L next-window

      # bind r command-prompt "rename-window %%"
      # bind R source-file ~/.config/tmux/tmux.conf
      # bind ^A last-window
      # bind ^W list-windows
      bind w list-windows
      bind z resize-pane -Z
      # bind ^L refresh-client
      bind C-r refresh-client
      # bind | split-window
      # bind s split-window -v -c "#{pane_current_path}"
      # bind v split-window -h -c "#{pane_current_path}"
      # bind '"' choose-window
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      # bind -r -T prefix , resize-pane -L 20
      # bind -r -T prefix . resize-pane -R 20
      # bind -r -T prefix - resize-pane -D 7
      # bind -r -T prefix = resize-pane -U 7
      bind : command-prompt
      bind * setw synchronize-panes
      # bind P set pane-border-status
      # bind c kill-pane
      # bind x swap-pane -D
      # bind S choose-session
      bind-key -T copy-mode-vi v send-keys -X begin-selection '';
  };
}

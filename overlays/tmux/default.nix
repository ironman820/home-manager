{ channels, ... }:
final: prev: {
  tmuxPlugins = prev.tmuxPlugins // {
    inherit (prev.ironman) catppuccin-tmux tmux-session-wizard;
  };
}

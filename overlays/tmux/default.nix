{ channels, ... }:
final: prev:
{
  inherit (prev.ironman) t;
  tmuxPlugins = prev.tmuxPlugins // {
    inherit (prev.ironman) tmux-session-wizard;
  };
}

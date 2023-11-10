{ channels, ... }:
final: prev:
{
  vimPlugins = prev.vimPlugins // {
    inherit (prev.ironman) cmp-nerdfont nvim-undotree;
    inherit (channels.unstable.vimPlugins) efmls-configs-nvim;
  };
}

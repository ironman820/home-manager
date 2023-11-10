{ channels, ... }:
final: prev:
{
  vimPlugins = prev.vimPlugins // {
    inherit (prev.ironman) cmp-nerdfont nvim-undotree;
  };
}

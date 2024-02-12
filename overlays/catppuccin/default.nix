{ channels, ... }:
final: prev:
{
  inherit (prev.mine) catppuccin-btop catppuccin-lazygit;
}

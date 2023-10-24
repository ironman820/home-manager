{ channels, ... }:
final: prev:
{
  inherit (channels.nixpkgs-23-05) telegram-desktop;
}

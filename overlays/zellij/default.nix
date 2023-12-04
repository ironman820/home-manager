{ channels, ... }:
final: prev:
{
  inherit (channels.unstable) zellij;
}

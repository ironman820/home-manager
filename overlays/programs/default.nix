{ channels, ... }:
final: prev:
{
  inherit (prev.ironman) switchssh;
}

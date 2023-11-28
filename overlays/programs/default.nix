{ channels, ... }:
final: prev:
{
  inherit (prev.ironman) s switchssh;
}

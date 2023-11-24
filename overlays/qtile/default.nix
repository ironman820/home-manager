{ channels, ... }:
final: prev:
{
  python3Packages = prev.python3Packages // {
    inherit (channels.unstable.python3Packages) qtile qtile-extras;
  };
}

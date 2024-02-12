{ config, format, home, host, inputs, lib, pkgs, systems, target, virtual, ...}:
let
  inherit (lib.mine) enabled;
in
{
  mine.home = {
    personal-apps = enabled;
    suites.virtual-workstation = enabled;
    user.name = config.snowfallorg.user.name;
  };
}

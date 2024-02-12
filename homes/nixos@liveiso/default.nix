{ config, lib, ...}:
let
  inherit (lib.mine) enabled;
in
{
  mine.home = {
    suites.virtual-workstation = enabled;
    user.name = config.snowfallorg.user.name;
  };
}

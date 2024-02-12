{ config, format, home, host, inputs, lib, pkgs, systems, target, virtual, ...}:
with lib;
with lib.mine;
{
  mine.home = {
    suites.server = enabled;
    user.name = config.snowfallorg.user.name;
  };
}

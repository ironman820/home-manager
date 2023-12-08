{ config, lib, ...}:
let inherit (lib.ironman) enabled;
in {
  ironman.home = {
    suites.server = {
      enable = true;
      rcm2 = enabled;
    };
    user.name = config.snowfallorg.user.name;
  };
}

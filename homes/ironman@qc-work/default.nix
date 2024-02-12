{ config, lib, ...}:
let inherit (lib.mine) enabled;
in {
  mine.home = {
    suites.server = enabled;
    user.name = config.snowfallorg.user.name;
  };
}

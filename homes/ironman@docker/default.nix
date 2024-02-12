{ lib, ... }:
let inherit (lib.mine) enabled;
in {
  mine.home = {
    programs = { ranger = enabled; };
    sops.install = true;
    suites.server = enabled;
  };
}

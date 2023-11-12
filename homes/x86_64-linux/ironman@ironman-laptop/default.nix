{ config, format, home, host, inputs, lib, pkgs, systems, target, virtual, ...}:
let
  inherit (lib.ironman) enabled;
  inherit (pkgs.ironman) blockyalarm;
in
{
  ironman.home = {
    networking = enabled;
    neomutt = enabled;
    personal-apps = enabled;
    programs.ranger = enabled;
    qtile = {
      enable = true;
      backlightDisplay = "intel_backlight";
      screenSizeCommand = "xrandr --output eDP-1 --primary --auto --scale 1.2";
    };
    suites.workstation = enabled;
  };
}

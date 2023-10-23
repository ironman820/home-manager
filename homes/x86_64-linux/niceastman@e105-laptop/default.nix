{ config, format, home, host, inputs, lib, pkgs, systems, target, virtual, ...}:
let
  inherit (lib.ironman) enabled;
in
{
  home = {
    file.".config/is_personal".text = ''false'';
    packages = [
        pkgs.ironman.blockyalarm
    ];
  };
  ironman.home = {
    hyprland = {
        enable = true;
        wallpaper = ./voidbringer.png;
    };
    networking = enabled;
    suites.workstation = enabled;
    user = enabled;
    work-tools = enabled;
  };
  # systemd.user = {
  #   services."leave" = {
  #     Unit.Description = "blockyalarm Go Home";
  #     Install.WantedBy = [ "default.target" ];
  #     Service.ExecStart = ''${pkgs.ironman.blockyalarm}/bin/blockyalarm "Get out of the office!"'';
  #   };
  #   timers."leave" = {
  #     Install.WantedBy = [ "timers.target" ];
  #     Timer.OnCalendar = "Mon..Fri 17:00,15:00";
  #   };
  # };
}

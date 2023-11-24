{ lib, pkgs, ... }:
let
  inherit (lib.ironman) enabled;
in {
  home = {
    file.".config/is_personal".text = "false";
    packages = [ pkgs.ironman.blockyalarm ];
  };
  ironman.home = {
    sops.secrets.github_home.sopsFile = ./secrets/work-keys.yaml;
    networking = enabled;
    programs = {
      neomutt = {
        enable = true;
        workEmail = true;
      };
      ranger = enabled;
    };
    suites.workstation = enabled;
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

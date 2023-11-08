{ config, format, home, host, inputs, lib, pkgs, systems, target, virtual, ...}:
let
  inherit (lib.ironman) enabled;
  email = config.sops.secrets.royell_email.path;
in
{
  home = {
    file.".config/is_personal".text = ''false'';
    packages = [
        pkgs.ironman.blockyalarm
    ];
  };
  ironman.home = {
    sops.secrets.github.sopsFile = ./secrets/github_work.age;
    neomutt = {
      enable = true;
      accounts = {
        royell = {
          imap.host = "mail.royell.org";
          primary = true;
        };
      };
    };
    networking = enabled;
    programs = {
      nvim.enableLSP = true;
      ranger = enabled;
    };
    sops.secrets.royell_email = {};
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

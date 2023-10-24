{ config, inputs, lib, options, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.ironman) enabled mkOpt;
  inherit (lib.types) attrs;

  cfg = config.ironman.home.neomutt;
in {
  options.ironman.home.neomutt = {
    enable = mkEnableOption "Install Neomutt";
    accounts = mkOpt attrs {} "Email Account Settings";
  };

  config = mkIf cfg.enable {
    accounts.email = cfg.accounts;
    home.packages = with pkgs; [
      abook
      browsh
      cacert
      curl
      gettext
      isync
      lynx
      mutt-wizard
      msmtp
      notmuch
      pass
      urlview
    ];
    programs.neomutt = {
      enable = true;
      sidebar = {
        enable = true;
        extraConfig = ''
          set mail_check_status
        '';
        format = "%B %*%<N?%N>";
      };
    };
    systemd.user = {
      services."mailsync" = {
        Unit.Description = "Mail sync for Neomutt";
        Install.WantedBy = [ "default.target" ];
        Service.ExecStart = ''${pkgs.mutt-wizard}/bin/mailsync'';
      };
      timers."mailsync" = {
        Install.WantedBy = [ "timers.target" ];
        Timer.OnUnitInactiveSec = "5min";
      };
    };
  };
}

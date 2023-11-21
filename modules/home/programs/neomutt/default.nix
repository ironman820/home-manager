{ config, lib, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (lib) mkEnableOption mkIf mkMerge;
  inherit (lib.ironman) enabled;

  cfg = config.ironman.home.programs.neomutt;
  modFolder = "${config.xdg.configHome}/home-manager/modules/home/programs/neomutt";
in {
  options.ironman.home.programs.neomutt = {
    enable = mkEnableOption "Install Neomutt";
    personalEmail = mkEnableOption "Setup Personal Email";
    workEmail = mkEnableOption "Setup Work Email";
  };

  config = mkIf cfg.enable (let
      sopsFile = ./secrets/neomutt.yaml;
    in {
      ironman.home.sops.secrets = mkMerge [
        (mkIf cfg.personalEmail {
          "mbsync_personal_email" = {
            inherit sopsFile;
            path = "${config.home.homeDirectory}/.mbsyncrc";
          };
          "muttrc_personal_email" = {
            inherit sopsFile;
            path = "${config.xdg.configHome}/mutt/accounts/master.muttrc";
          };
          "msmtp_personal_config" = {
            inherit sopsFile;
            path = "${config.xdg.configHome}/msmtp/config";
          };
        })
        (mkIf cfg.workEmail {
          "mbsync_work_email" = {
            inherit sopsFile;
            path = "${config.home.homeDirectory}/.mbsyncrc";
          };
          "muttrc_work_email" = {
            inherit sopsFile;
            path = "${config.xdg.configHome}/mutt/accounts/master.muttrc";
          };
          "msmtp_work_config" = {
            inherit sopsFile;
            path = "${config.xdg.configHome}/msmtp/config";
          };
        })
      ];
      home = {
        packages = with pkgs; [
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
      };
      programs.neomutt = enabled;
      xdg.configFile = {
        "mutt/mailcap".source = mkOutOfStoreSymlink "${modFolder}/mailcap";
        "mutt/muttrc".source = mkOutOfStoreSymlink "${modFolder}/muttrc";
        "mutt/mutt-wizard.muttrc".source = mkOutOfStoreSymlink "${modFolder}/mutt-wizard.muttrc";
        "mutt/switch.muttrc".source = mkOutOfStoreSymlink "${modFolder}/switch.muttrc";
        "mutt/theme".source = "${pkgs.catppuccin-neomutt}/catppuccin-neomutt";
      };
    });
}

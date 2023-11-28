{ config, lib, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (lib) mkEnableOption mkIf mkMerge;
  inherit (lib.ironman) enabled;

  cfg = config.ironman.home.programs.neomutt;
  modFolder =
    "${config.xdg.configHome}/home-manager/modules/home/programs/neomutt";
  configFolder = "${config.xdg.configHome}/mutt";
in {
  options.ironman.home.programs.neomutt = {
    enable = mkEnableOption "Install Neomutt";
    personalEmail = mkEnableOption "Setup Personal Email";
    workEmail = mkEnableOption "Setup Work Email";
  };

  config = mkIf cfg.enable (let sopsFile = ./secrets/neomutt.yaml;
  in {
    ironman.home.sops.secrets = mkMerge [
      {
        "mbsync" = {
          inherit sopsFile;
          path = "${config.home.homeDirectory}/.mbsyncrc";
        };
        "msmtp_config" = {
          inherit sopsFile;
          path = "${config.xdg.configHome}/msmtp/config";
        };
        "work_sig" = {
          inherit sopsFile;
          path = "${configFolder}/signatures/work.sig";
        };
        "personal_sig" = {
          inherit sopsFile;
          path = "${configFolder}/signatures/personal.sig";
        };
      }
      (mkIf cfg.personalEmail {
        "muttrc_personal_email" = {
          inherit sopsFile;
          path = "${configFolder}/accounts/master.muttrc";
        };
        "muttrc_work_email" = {
          inherit sopsFile;
          path = "${configFolder}/accounts/work.muttrc";
        };
      })
      (mkIf cfg.workEmail {
        "muttrc_work_email" = {
          inherit sopsFile;
          path = "${configFolder}/accounts/master.muttrc";
        };
        "muttrc_personal_email" = {
          inherit sopsFile;
          path = "${configFolder}/accounts/personal.muttrc";
        };
      })
    ];
    home = {
      packages = with pkgs; [
        abook
        browsh
        cacert
        curl
        fim
        gettext
        isync
        lynx
        mutt-wizard
        msmtp
        notmuch
        pass
        urlview
      ];
      shellAliases = { mail = "neomutt"; };
    };
    programs.neomutt = enabled;
    xdg.configFile = {
      "mutt/mailcap".source = mkOutOfStoreSymlink "${modFolder}/mailcap";
      "mutt/muttrc".source = mkOutOfStoreSymlink "${modFolder}/muttrc";
      "mutt/mutt-wizard.muttrc".source =
        mkOutOfStoreSymlink "${modFolder}/mutt-wizard.muttrc";
      "mutt/switch.muttrc".source =
        mkOutOfStoreSymlink "${modFolder}/switch.muttrc";
      "mutt/theme".source = "${pkgs.catppuccin-neomutt}/catppuccin-neomutt";
    };
  });
}

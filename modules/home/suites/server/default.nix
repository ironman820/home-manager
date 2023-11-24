{ config, lib, pkgs, system, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.ironman) enabled;
  cfg = config.ironman.home.suites.server;
in
{
  options.ironman.home.suites.server = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    ironman.home = {
      sops.secrets = {
        github_home.sopsFile = ./secrets/servers.yaml;
        royell_git_work.sopsFile = ./secrets/servers.yaml;
      };
      tmux.shortcut = "t";
    };
  };
}

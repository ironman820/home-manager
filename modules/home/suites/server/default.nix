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
        github.sopsFile = ./secrets/github_servers.age;
        royell_git.sopsFile = ./secrets/royell_git_servers.age;
      };
      lf = enabled;
      tmux.shortcut = "t";
    };
  };
}

{ config, inputs, lib, options, pkgs, ... }:
let
  inherit (lib) mkAliasDefinitions mkDefault mkIf mkMerge;
  inherit (lib.ironman) mkBoolOpt mkOpt;
  inherit (lib.types) attrs path;
  cfg = config.ironman.home.sops;
in {
  options.ironman.home.sops = {
    enable = mkBoolOpt true "Enable root secrets";
    age = mkOpt attrs { } "Age Attributes";
    defaultSopsFile = mkOpt path ./secrets/keys.yaml "Default SOPS file path.";
    secrets = mkOpt attrs { } "SOPS secrets.";
  };

  config = mkIf cfg.enable {
    ironman.home.sops = {
      age = {
        keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
        sshKeyPaths = [ ];
      };
      secrets = mkMerge [{
        github_home = {
          mode = "0400";
          path = "${config.home.homeDirectory}/.ssh/github";
        };
        github_home_pub = {
          mode = "0400";
          path = "${config.home.homeDirectory}/.ssh/github_home.pub";
        };
        github_servers_pub = {
          mode = "0400";
          path = "${config.home.homeDirectory}/.ssh/github_servers.pub";
        };
        github_work_pub = {
          mode = "0400";
          path = "${config.home.homeDirectory}/.ssh/github_work.pub";
        };
        royell_git_work = {
          mode = "0400";
          path = "${config.home.homeDirectory}/.ssh/royell_git";
          sopsFile = mkDefault ./secrets/work-keys.yaml;
        };
        royell_git_servers_pub = {
          mode = "0400";
          path = "${config.home.homeDirectory}/.ssh/royell_git_servers.pub";
          sopsFile = ./secrets/work-keys.yaml;
        };
        royell_git_work_pub = {
          mode = "0400";
          path = "${config.home.homeDirectory}/.ssh/royell_git_work.pub";
          sopsFile = ./secrets/work-keys.yaml;
        };
      }];
    };
    sops = {
      age = mkAliasDefinitions options.ironman.home.sops.age;
      defaultSopsFile =
        mkAliasDefinitions options.ironman.home.sops.defaultSopsFile;
      gnupg.sshKeyPaths = [ ];
      secrets = mkAliasDefinitions options.ironman.home.sops.secrets;
    };
  };
}

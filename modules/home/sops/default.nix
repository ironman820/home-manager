{ config, inputs, lib, options, pkgs, ... }:
let
  inherit (lib) mkAliasDefinitions mkDefault mkIf mkMerge;
  inherit (lib.ironman) mkBoolOpt mkOpt;
  inherit (lib.types) attrs path;
  cfg = config.ironman.home.sops;
in
{
  options.ironman.home.sops = {
    enable = mkBoolOpt true "Enable root secrets";
    age = mkOpt attrs { } "Age Attributes";
    defaultSopsFile = mkOpt path ./secrets/sops.yaml "Default SOPS file path.";
    secrets = mkOpt attrs { } "SOPS secrets.";
  };

  config = mkIf cfg.enable {
    ironman.home.sops = {
      age = {
        keyFile = "/home/${config.ironman.home.user.name}/.config/sops/age/keys.txt";
        sshKeyPaths = [];
      };
      secrets = mkMerge [
        {
          github = {
            mode = "0400";
            path = "/home/${config.ironman.home.user.name}/.ssh/github";
            sopsFile = mkDefault ./secrets/github_home.age;
            format = "binary";
          };
          github_home_pub = {
            mode = "0400";
            path = "/home/${config.ironman.home.user.name}/.ssh/github_home.pub";
            sopsFile = ./secrets/github_home.pub.age;
            format = "binary";
          };
          github_servers_pub = {
            mode = "0400";
            path = "/home/${config.ironman.home.user.name}/.ssh/github_servers.pub";
            sopsFile = ./secrets/github_servers.pub.age;
            format = "binary";
          };
          github_work_pub = {
            mode = "0400";
            path = "/home/${config.ironman.home.user.name}/.ssh/github_work.pub";
            sopsFile = ./secrets/github_work.pub.age;
            format = "binary";
          };
          royell_git = {
            mode = "0400";
            path = "/home/${config.ironman.home.user.name}/.ssh/royell_git";
            sopsFile = mkDefault ./secrets/royell_git_work.age;
            format = "binary";
          };
          royell_git_servers_pub = {
            mode = "0400";
            path = "/home/${config.ironman.home.user.name}/.ssh/royell_git_servers.pub";
            sopsFile = ./secrets/royell_git_servers.pub.age;
            format = "binary";
          };
          royell_git_work_pub = {
            mode = "0400";
            path = "/home/${config.ironman.home.user.name}/.ssh/royell_git_work.pub";
            sopsFile = ./secrets/royell_git_work.pub.age;
            format = "binary";
          };
        }
      ];
    };
    sops = {
      age = mkAliasDefinitions options.ironman.home.sops.age;
      defaultSopsFile = mkAliasDefinitions options.ironman.home.sops.defaultSopsFile;
      gnupg.sshKeyPaths = [];
      secrets = mkAliasDefinitions options.ironman.home.sops.secrets;
    };
  };
}

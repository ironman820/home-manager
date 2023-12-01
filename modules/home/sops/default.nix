{ config, lib, options, pkgs, ... }:
let
  inherit (lib) mkAliasDefinitions mkDefault mkIf mkMerge;
  inherit (lib.ironman) mkBoolOpt mkOpt;
  inherit (lib.types) attrs path;
  cfg = config.ironman.home.sops;
  mode = "0400";
  sopsFile = ./secrets/work-keys.yaml;
in {
  options.ironman.home.sops = {
    enable = mkBoolOpt true "Enable root secrets";
    age = mkOpt attrs { } "Age Attributes";
    defaultSopsFile = mkOpt path ./secrets/keys.yaml "Default SOPS file path.";
    install = mkBoolOpt false "Install sops in home manager";
    secrets = mkOpt attrs { } "SOPS secrets.";
  };

  config = mkIf cfg.enable {
    ironman.home.sops = {
      age = {
        keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
        sshKeyPaths = [ ];
      };
      secrets = mkMerge [{
        authorized_keys = {
          inherit mode;
          path = "${config.home.homeDirectory}/.ssh/authorized_keys";
        };
        github_home = {
          inherit mode;
          path = "${config.home.homeDirectory}/.ssh/github";
        };
        github_home_pub = {
          inherit mode;
          path = mkDefault "${config.home.homeDirectory}/.ssh/github.pub";
        };
        github_servers_pub = {
          inherit mode;
          path =
            mkDefault "${config.home.homeDirectory}/.ssh/github_servers.pub";
        };
        github_work_pub = {
          inherit mode;
          path = mkDefault "${config.home.homeDirectory}/.ssh/github_work.pub";
        };
        id_ed25519_sk = {
          inherit mode;
          path = mkDefault "${config.home.homeDirectory}/.ssh/id_ed25519_sk";
        };
        id_ed25519_sk_pub = {
          inherit mode;
          path =
            mkDefault "${config.home.homeDirectory}/.ssh/id_ed25519_sk.pub";
        };
        id_ed25519_sk_work_pub = {
          inherit mode;
          path = mkDefault
            "${config.home.homeDirectory}/.ssh/id_ed25519_sk_work.pub";
        };
        id_ed25519_sk_work2_pub = {
          inherit mode;
          path = mkDefault
            "${config.home.homeDirectory}/.ssh/id_ed25519_sk_work2.pub";
        };
        id_rsa_yubikey_pub = {
          inherit mode;
          path =
            mkDefault "${config.home.homeDirectory}/.ssh/id_rsa_yubikey.pub";
        };
        my-config = {
          inherit mode;
          format = "binary";
          sopsFile = ./secrets/my-config.sops;
          path = "${config.home.homeDirectory}/.ssh/my-config";
        };
        royell_git_work = {
          inherit mode sopsFile;
          path = "${config.home.homeDirectory}/.ssh/royell_git";
        };
        royell_git_servers_pub = {
          inherit mode sopsFile;
          path = "${config.home.homeDirectory}/.ssh/royell_git_servers.pub";
        };
        royell_git_work_pub = {
          inherit mode sopsFile;
          path = "${config.home.homeDirectory}/.ssh/royell_git.pub";
        };
        yb_keys = {
          inherit mode;
          format = "binary";
          sopsFile = ./secrets/yb_keys.sops;
          path = "${config.xdg.configHome}/Yubico/u2f_keys";
        };
      }];
    };
    home.packages = mkIf cfg.install (with pkgs; [ sops ]);
    sops = {
      age = mkAliasDefinitions options.ironman.home.sops.age;
      defaultSopsFile =
        mkAliasDefinitions options.ironman.home.sops.defaultSopsFile;
      gnupg.sshKeyPaths = [ ];
      secrets = mkAliasDefinitions options.ironman.home.sops.secrets;
    };
  };
}

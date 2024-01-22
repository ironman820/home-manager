{
  pkgs,
  config,
  host,
  lib,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  inherit (lib.ironman) mkBoolOpt mkIfElse;

  cfg = config.ironman.home.just;
in {
  options.ironman.home.just = {enable = mkBoolOpt true "Install Just";};

  config = mkIf cfg.enable {
    home = {
      file.".justfile".text = mkMerge [
        ''
          default:
            @just --list

          apps:
            flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            flatpak install -uy com.usebottles.bottles
            flatpak install -uy com.github.tchx84.Flatseal
            flatpak install -uy org.gnome.gitlab.YaLTeR.VideoTrimmer

          bios:
            systemctl reboot --firmware-setup

          switch:
            flake switch ~/.config/flake#
        ''
        (
          mkIfElse (host == "e105-laptop" || host == "ironman-laptop")
          ''
            home-switch:
              home-manager switch --flake $(find ~/.config/home-manager/branches -maxdepth 1 -type d ! \( -name '.*' -o -name '*branches' \) -print | fzf)
              systemctl --user restart sops-nix.service
          ''
          ''
            home-switch:
              home-manager switch
              systemctl --user restart sops-nix.service
          ''
        )
        ''
          update:
            #!/usr/bin/env bash
            cd ~/.config/flake
            flake update
            flake switch
            cd ~/.config/home-manager
            flake update
            home-manager switch
            systemctl --user restart sops-nix.service
            flatpak update -y
        ''
      ];
      packages = with pkgs; [just];
      shellAliases = {
        "hs" = "just home-switch";
        "js" = "just switch";
        "ju" = "just update";
      };
    };
  };
}

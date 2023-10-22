{ config, inputs, lib, options, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.ironman) enabled;

  cfg = config.ironman.home.hyprland;
in {
  options.ironman.home.hyprland = {
    enable = mkEnableOption "Setup hyprland";
  };

  config = mkIf cfg.enable {
    home.file.".config/hypr/hyprland.conf".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/modules/home/hyprland/hyprland.conf";
  };
}

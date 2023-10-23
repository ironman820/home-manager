{ config, inputs, lib, options, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.ironman) enabled;

  cfg = config.ironman.home.waybar;
in {
  options.ironman.home.waybar = {
    enable = mkEnableOption "Setup waybar";
  };

  config = mkIf cfg.enable {
    home.file.".config/waybar".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/modules/home/waybar/config";
  };
}

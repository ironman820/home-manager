{ config, inputs, lib, options, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.ironman) enabled;

  cfg = config.ironman.home.qtile;
in {
  options.ironman.home.qtile = {
    enable = mkEnableOption "Enable the qtile file manager";
  };

  config = mkIf cfg.enable {
    xdg.configFile."qtile".source = mkOutOfStoreSymlink "/home/${config.ironman.home.user.name}/.config/home-manager/modules/home/qtile/config";
  };
}

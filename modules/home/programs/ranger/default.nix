{ config, inputs, lib, options, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.ironman) enabled;

  cfg = config.ironman.home.programs.ranger;
in {
  options.ironman.home.programs.ranger = {
    enable = mkEnableOption "Enable the ranger file manager";
  };

  config = mkIf cfg.enable {
    home.packages = (with pkgs; [
      bashmount
      file
      ranger
      trashy
    ]);
    xdg.configFile."ranger/commands.py".source = mkOutOfStoreSymlink "/home/${config.ironman.home.user.name}/.config/home-manager/modules/home/programs/ranger/config/commands.py";
    xdg.configFile."ranger/rc.conf".source = mkOutOfStoreSymlink "/home/${config.ironman.home.user.name}/.config/home-manager/modules/home/programs/ranger/config/rc.conf";
    xdg.configFile."ranger/rifle.conf".source = mkOutOfStoreSymlink "/home/${config.ironman.home.user.name}/.config/home-manager/modules/home/programs/ranger/config/rifle.conf";
    xdg.configFile."ranger/scope.sh".source = mkOutOfStoreSymlink "/home/${config.ironman.home.user.name}/.config/home-manager/modules/home/programs/ranger/config/scope.sh";
    xdg.configFile."ranger/plugins/ranger_devicons".source = inputs.ranger-devicons;
  };
}

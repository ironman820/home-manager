{ config, lib, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.types) str;
  inherit (lib.ironman) mkOpt;
  inherit (pkgs) writeShellScript;

  cfg = config.ironman.home.qtile;
in {
  options.ironman.home.qtile = {
    enable = mkEnableOption "Enable the qtile file manager";
    backlightDisplay = mkOpt str "acpi_video0" "Display to monitor backlight";
    screenSizeCommand =
      mkOpt str "" "Command to run to change the screen resolution.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      flameshot
    ];
    xdg.configFile."qtile/autostart.sh".source =
      writeShellScript "autostart.sh" ''
        ${cfg.screenSizeCommand}
        nm-applet &
      '';
    xdg.configFile."qtile/config.py".source = mkOutOfStoreSymlink
      "/home/${config.ironman.home.user.name}/.config/home-manager/modules/home/qtile/config/config.py";
    xdg.configFile."qtile/display.py".text = ''
      watch_display = "${cfg.backlightDisplay}"
    '';
    xdg.configFile."qtile/settings".source = mkOutOfStoreSymlink
      "/home/${config.ironman.home.user.name}/.config/home-manager/modules/home/qtile/config/settings";
  };
}

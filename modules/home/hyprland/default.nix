{ config, inputs, lib, options, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.ironman) enabled mkOpt;
  inherit (lib.strings) concatStringsSep;
  inherit (lib.types) either path str;
  inherit (pkgs) writeShellScriptBin;

  cfg = config.ironman.home.hyprland;
in {
  options.ironman.home.hyprland = {
    enable = mkEnableOption "Setup hyprland";
    primaryScale = mkOpt str "1" "Scaling factor for the primary monitor";
    wallpaper = mkOpt (either path str) "" "Wallpaper to load with hyprpaper";
  };

  config = mkIf cfg.enable {
    home = {
      file = let
        inherit (cfg) primaryScale;
        in {
        ".config/hypr/hyprland.conf".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/modules/home/hyprland/hyprland-config/hyprland.conf";
        ".config/hypr/monitor.conf".text = concatStringsSep "\n" [
          "monitor=HDMI-A-1,preferred,auto,1,mirror,eDP-1"
          "monitor=,highres,auto,${primaryScale}"
          "$mainMod = SUPER"
          "bind = $mainMod, P, exec, hyprctl keyword monitor \"eDP-1,1280x720,auto,1\""
          "bind = $mainMod SHIFT, P, exec, hyprctl keyword monitor \"eDP-1,highres,auto,${primaryScale}\""
          "bindl = , switch:off:Lid Switch,exec,hyprctl keyword monitor \"eDP-1, highres, auto, ${primaryScale}\""
          "bindl = , switch:on:Lid Switch,exec,hyprctl keyword monitor \"eDP-1, disable\""
        ];
        ".config/hypr/hyprpaper.conf".text = mkIf (cfg.wallpaper != "") ''
            preload = ${cfg.wallpaper}
            wallpaper = , ${cfg.wallpaper}
        '';
        ".config/hyprland-autoname-workspaces/config.toml".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/modules/home/hyprland/hyprland-autoname-workspaces.toml";
        ".config/hypr/waybar.conf".text = ''
           exec-once = ${pkgs.ironman.start-waybar}/bin/start-waybar &
        '';
        ".config/waybar".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/modules/home/hyprland/waybar-config";
      };
      packages = with pkgs.ironman; [
        start-waybar
      ];
    };
  };
}

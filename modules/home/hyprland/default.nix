{ config, inputs, lib, options, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.ironman) enabled mkOpt;
  inherit (lib.strings) concatStringsSep;
  inherit (lib.types) either path str;

  cfg = config.ironman.home.hyprland;
in {
  options.ironman.home.hyprland = {
    enable = mkEnableOption "Setup hyprland";
    primaryScale = mkOpt str "1" "Scaling factor for the primary monitor";
    wallpaper = mkOpt (either path str) "" "Wallpaper to load with hyprpaper";
  };

  config = mkIf cfg.enable {
    ironman.home.waybar = enabled;
    home = {
      file = let
        inherit (cfg) primaryScale;
        in {
        ".config/hypr/hyprland.conf".text = concatStringsSep "\n" [
          "monitor=HDMI-A-1,highrr,auto,1,mirror,eDP-1"
          "monitor=,highres,auto,${primaryScale}"
          "exec-once = waybar"
          "exec-once = mako"
          "exec-once = polkit-kde-authentication-agent-1"
          "exec-once = hyprpaper"
          "env = XCURSOR_SIZE,24"
          "env = WLR_NO_HARDWARE_CURSORS,1"
          "input {"
              "kb_layout = us"
              "kb_variant ="
              "kb_model ="
              "kb_options ="
              "kb_rules ="
              "follow_mouse = 0"
              "touchpad {"
                  "natural_scroll = yes"
              "}"
              "sensitivity = 0 # -1.0 - 1.0, 0 means no modification."
          "}"
          "general {"
              "gaps_in = 5"
              "gaps_out = 10"
              "border_size = 2"
              "col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg"
              "col.inactive_border = rgba(595959aa)"
              "layout = dwindle"
          "}"
          "decoration {"
              "rounding = 10"
              "blur = yes"
              "blur_size = 3"
              "blur_passes = 1"
              "blur_new_optimizations = on"
              "drop_shadow = yes"
              "shadow_range = 4"
              "shadow_render_power = 3"
              "col.shadow = rgba(1a1a1aee)"
          "}"
          "animations {"
              "enabled = yes"
              "bezier = myBezier, 0.05, 0.9, 0.1, 1.05"
              "animation = windows, 1, 7, myBezier"
              "animation = windowsOut, 1, 7, default, popin 80%"
              "animation = border, 1, 10, default"
              "animation = borderangle, 1, 8, default"
              "animation = fade, 1, 7, default"
              "animation = workspaces, 1, 6, default"
          "}"
          "dwindle {"
              "pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below"
              "preserve_split = yes # you probably want this"
          "}"
          "master {"
              "new_is_master = true"
          "}"
          "gestures {"
              "workspace_swipe = off"
          "}"
          "device:epic-mouse-v1 {"
              "sensitivity = -0.5"
          "}"
          "$mainMod = SUPER"
          "bind = $mainMod, F, exec, dolphin"
          "bind = $mainMod, J, togglesplit, # dwindle"
          "bind = $mainMod SHIFT, L, exec, swaylock --screenshots --clock --effect-pixelate 5 --fade-in 3 --effect-vignette 0.3:0.5"
          "bind = $mainMod, M, exit,"
          "bind = $mainMod, P, exec, hyprctl keyword monitor \"eDP-1,1280x720@60,auto,${primaryScale}\""
          "bind = $mainMod SHIFT, P, exec, hyprctl keyword monitor \"eDP-1,highres,auto,${primaryScale}\""
          "bind = $mainMod, Q, killactive,"
          "bind = $mainMod, R, exec, rofi -show drun -show-icons"
          "bind = $mainMod, T, exec, kitty"
          "bind = $mainMod, V, togglefloating,"
          "bind = $mainMod, W, exec, brave"
          "bind = , print, exec, watershot -c directory $HOME/Pictures/\\[01\\]-Screenshots/"
          "bind = $mainMod, H, movefocus, l"
          "bind = $mainMod, L, movefocus, r"
          "bind = $mainMod, K, movefocus, u"
          "bind = $mainMod, J, movefocus, d"
          "bind = $mainMod, 1, workspace, 1"
          "bind = $mainMod, 2, workspace, 2"
          "bind = $mainMod, 3, workspace, 3"
          "bind = $mainMod, 4, workspace, 4"
          "bind = $mainMod, 5, workspace, 5"
          "bind = $mainMod, 6, workspace, 6"
          "bind = $mainMod, 7, workspace, 7"
          "bind = $mainMod, 8, workspace, 8"
          "bind = $mainMod, 9, workspace, 9"
          "bind = $mainMod, 0, workspace, 10"
          "bind = $mainMod SHIFT, 1, movetoworkspace, 1"
          "bind = $mainMod SHIFT, 2, movetoworkspace, 2"
          "bind = $mainMod SHIFT, 3, movetoworkspace, 3"
          "bind = $mainMod SHIFT, 4, movetoworkspace, 4"
          "bind = $mainMod SHIFT, 5, movetoworkspace, 5"
          "bind = $mainMod SHIFT, 6, movetoworkspace, 6"
          "bind = $mainMod SHIFT, 7, movetoworkspace, 7"
          "bind = $mainMod SHIFT, 8, movetoworkspace, 8"
          "bind = $mainMod SHIFT, 9, movetoworkspace, 9"
          "bind = $mainMod SHIFT, 0, movetoworkspace, 10"
          "bind = $mainMod, mouse_down, workspace, e+1"
          "bind = $mainMod, mouse_up, workspace, e-1"
          "bindl = , switch:off:Lid Switch,exec,hyprctl keyword monitor \"eDP-1, highres, auto, ${primaryScale}\""
          "bindl = , switch:on:Lid Switch,exec,hyprctl keyword monitor \"eDP-1, disable\""
          "bindm = $mainMod, mouse:272, movewindow"
          "bindm = $mainMod, mouse:273, resizewindow"
        ];
        ".config/hypr/hyprpaper.conf".text = mkIf (cfg.wallpaper != "") ''
            preload = ${cfg.wallpaper}
            wallpaper = , ${cfg.wallpaper}
        '';
      };
    };
  };
}

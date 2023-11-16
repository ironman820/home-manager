{ config, lib, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (lib) mkDefault mkForce mkIf;
  inherit (lib.ironman) mkBoolOpt mkOpt;
  inherit (lib.types) attrs lines;
  inherit (pkgs) nerdfonts;

  cfg = config.ironman.home.kitty;
in {
  options.ironman.home.kitty = {
    enable = mkBoolOpt true "Setup kitty";
    extraConfig = mkOpt lines '''' "Extra configuration options";
    settings = mkOpt attrs {
      background_opacity = mkForce "0.9";
      cursor_shape = mkDefault "beam";
      enable_audio_bell = mkDefault false;
      font_family = mkDefault "FiraCode Nerd Font Mono";
      scrollback_lines = mkDefault 10000;
      scrollback_pager = mkDefault "bat";
      tab_bar_style = mkDefault "powerline";
      update_check_interval = mkDefault 0;
    } "Settings from the kitty config file";
  };

  config = mkIf cfg.enable {
    ironman.home.kitty.extraConfig = ''
      include current-theme.conf
    '';
    home = {
      file.".config/kitty/current-theme.conf".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/modules/home/kitty/theme.conf";
      packages = [
        nerdfonts
      ];
    };
    programs.kitty = {
      inherit (cfg) extraConfig settings;
      enable = true;
    };
  };
}

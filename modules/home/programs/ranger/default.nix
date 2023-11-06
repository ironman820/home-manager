{ config, inputs, lib, options, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.ironman) enabled;

  cfg = config.ironman.home.programs.ranger;
in {
  options.ironman.home.programs.ranger = {
    enable = mkEnableOption "Enable the ranger file manager";
  };

  config = mkIf cfg.enable {
    home.packages = (with pkgs; [
      ranger
      trashy
    ]);
  };
}

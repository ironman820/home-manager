{ pkgs, config, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.ironman) mkBoolOpt;

  cfg = config.ironman.home.just;
in {
  options.ironman.home.just = { enable = mkBoolOpt true "Install Just"; };

  config = mkIf cfg.enable {
    home = {
      file.".justfile".source = ./justfile;
      packages = with pkgs; [ just ];
      shellAliases = {
        "hs" = "just home-switch";
        "js" = "just switch";
        "ju" = "just update";
      };
    };
  };
}


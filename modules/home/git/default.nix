{ config, lib, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (lib) mkIf;
  inherit (lib.ironman) enabled mkBoolOpt;

  cfg = config.ironman.home.git;
  configFolder = "${config.xdg.configHome}/lazygit";
  modFolder = "${config.xdg.configHome}/home-manager/modules/home/git/";
in {
  options.ironman.home.git = {
    enable = mkBoolOpt true "Setup git";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        git
        git-filter-repo
        github-cli
        glab
        lazygit
      ];
      sessionVariables = {
        LG_CONFIG_FILE = "${configFolder}/config.yml,${configFolder}/themes/mocha/red.yml";
      };
    };
    programs.git = {
      aliases = {
        pushall = "!git remote | xargs -L1 git push --all";
        graph = "log --decorate --oneline --graph";
        add-nowhitespace = "!git diff -U0 -w --no-color | git apply --cached --ignore-whitespace --undiff-zero -";
      };
      diff-so-fancy = enabled;
      enable = true;
      extraConfig = {
        feature.manyFiles = true;
        init.defaultBranch = "main";
        gpg.format = "ssh";
        merge.tool = "vimdiff";
      };
      ignores = [ ".direnv" "result" ];
      lfs = enabled;
      signing = {
        key = "~/.ssh/github";
        signByDefault = true;
      };
      userName = config.ironman.home.user.fullName;
      userEmail = config.ironman.home.user.email;
    };
    xdg.configFile = {
      "lazygit/config.yml".source = mkOutOfStoreSymlink "${modFolder}/lazygit.yml";
      "lazygit/themes".source = pkgs.catppuccin-lazygit;
    };
  };
}

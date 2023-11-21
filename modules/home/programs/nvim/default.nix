{ config, lib, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (lib) mkIf;
  inherit (lib.ironman) mkBoolOpt mkOpt;
  inherit (lib.types) lines;

  cfg = config.ironman.home.programs.nvim;
  initLua = ''

    require "lazy-load"
    require("settings.options")
    require("settings.keymaps")
    require("settings.barbecue")
    require("settings.cmp")
    require("settings.fidget")
    require("settings.git")
    require("settings.hop")
    require("settings.lspconfig")
    require("settings.mini")
    require("settings.telescope")
    require("settings.treesitter")
    require("settings.ufo")
    require("settings.undotree")
    require("settings.which-key")
  '';
  modFolder =
    "${config.home.homeDirectory}/.config/home-manager/modules/home/programs/nvim";
  telescope-fzf = pkgs.vimPlugins.telescope-fzf-native-nvim;
  treesitter = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
in {
  options.ironman.home.programs.nvim = {
    enable = mkBoolOpt true "Install NeoVim";
    extraLuaConfig = mkOpt lines initLua "Extra Config";
  };

  config = mkIf cfg.enable {
    home = {
      shellAliases = {
        "nano" = "nvim";
        "nv" = "nvim";
      };
    };
    programs.neovim = {
      inherit (cfg) enable extraLuaConfig;
      defaultEditor = true;
      extraPackages = (with pkgs; [
        fd
        ripgrep
        telescope-fzf
        tree-sitter
        treesitter
        xclip
        efm-langserver
        lua-language-server
        nil
        nixfmt
        statix
        stylua
      ]) ++ (with pkgs.luaPackages; [ luacheck ]);

      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
      withRuby = false;
    };
    xdg = {
      configFile."nvim/lua".source =
        mkOutOfStoreSymlink "${modFolder}/config/lua";
      dataFile = {
        "nvim/nix/nvim-treesitter/" = {
          recursive = true;
          source = treesitter;
        };
        "nvim/nix/telescope-fzf-native.nvim/" = {
          recursive = true;
          source = telescope-fzf;
        };
      };
    };
  };
}

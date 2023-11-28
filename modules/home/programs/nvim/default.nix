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
    require("settings.git")
    require("settings.hop")
    require("settings.lspconfig")
    require("settings.mini")
    require("settings.noice")
    require("settings.telescope")
    require("settings.treesitter")
    require("settings.ufo")
    require("settings.undotree")
    require("settings.vim-tmux-navigator")
    require("settings.which-key")
  '';
  modFolder =
    "${config.home.homeDirectory}/.config/home-manager/modules/home/programs/nvim";
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
        tree-sitter
        xclip
        efm-langserver
        lua-language-server
        mercurial
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
      configFile = {
        "nvim/lua".source = mkOutOfStoreSymlink "${modFolder}/config/lua";
        "nvim/parser".source = "${pkgs.symlinkJoin {
          name = "treesitter-parsers";
          paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
        }}/parser";
      };
      dataFile = {
        "nvim/nix/nvim-treesitter/" = {
          recursive = true;
          source = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
        };
        "nvim/nix/telescope-fzf-native.nvim/" = {
          recursive = true;
          source = pkgs.vimPlugins.telescope-fzf-native-nvim;
        };
      };
    };
  };
}

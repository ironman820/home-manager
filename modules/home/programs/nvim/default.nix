{ config, inputs, lib, options, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (lib) mkIf mkMerge types;
  inherit (lib.ironman) enabled mkBoolOpt mkOpt;
  inherit (lib.types) lines;

  cfg = config.ironman.home.programs.nvim;
  initLua = ''

    require "settings.keymaps"
    require "settings.options"
  '';
in {
  options.ironman.home.programs.nvim = {
    enable = mkBoolOpt true "Install NeoVim";
    enableLSP = mkBoolOpt false "Install LSP tools";
    extraLuaConfig = mkOpt lines initLua "Extra Config";
  };

  config = mkIf cfg.enable {
    home = {
      file = {
        ".config/nvim/lua".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/modules/home/programs/nvim/config/lua";
      };
      shellAliases = {
        "nano" = "nvim";
        "nv" = "nvim";
      };
    };
    programs.neovim = {
      inherit (cfg) enable extraLuaConfig;
      defaultEditor = true;
      extraPackages = with pkgs; [
        fd
        ripgrep
        tree-sitter
        pyright
        (python3.withPackages (py: with py; [
          python-lsp-server
          pyright
        ]))
      ];
      plugins = (with pkgs.vimPlugins; [
        cmp-cmdline
        cmp-buffer
        cmp-nvim-lsp
        cmp-nvim-ultisnips
        cmp-path
        cmp-rg
        dressing-nvim
        {
          plugin = nvim-autopairs;
          type = "lua";
          config = ''
            require("nvim-autopairs").setup()
          '';
        }
        {
          plugin = nvim-cmp;
          type = "lua";
          config = ''
            require "settings.cmp"
          '';
        }
        {
          plugin = nvim-lspconfig;
          type = "lua";
          config = ''
            require "settings.lspconfig"
          '';
        }
        {
          plugin = nvim-treesitter.withAllGrammars;
          type = "lua";
          config = ''
            require "settings.treesitter"
          '';
        }
        nvim-web-devicons
        plenary-nvim
        telescope-fzf-native-nvim
        {
          plugin = telescope-nvim;
          type = "lua";
          config = ''
            require "settings.telescope"
          '';
        }
        {
          plugin = tokyonight-nvim;
          config = ''
            colorscheme tokyonight-night
          '';
        }
        ultisnips
      ]) ++ (with pkgs.ironman; [
        cmp-nerdfont
      ]);
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
      withRuby = false;
    };
  };
}

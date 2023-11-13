{ config, inputs, lib, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (lib) mkIf mkMerge;
  inherit (lib.ironman) mkBoolOpt mkOpt;
  inherit (lib.types) lines;

  cfg = config.ironman.home.programs.nvim;
  initLua = ''

    require "settings.keymaps"
    require "settings.options"
  '';
  modFolder = "${config.home.homeDirectory}/.config/home-manager/modules/home/programs/nvim";
in {
  imports = [
    ./ufo.nix
  ];
  options.ironman.home.programs.nvim = {
    enable = mkBoolOpt true "Install NeoVim";
    enableLSP = mkBoolOpt false "Install LSP tools";
    extraLuaConfig = mkOpt lines initLua "Extra Config";
    qtile = mkBoolOpt false "Managing Qtile?";
  };

  config = mkIf cfg.enable {
    ironman.home.programs.nvim = mkIf cfg.qtile { enableLSP = true; };
    home = {
      file = {
        ".config/nvim/lua/.luarc.json".source = mkOutOfStoreSymlink "${modFolder}/config/lua/.luarc.conf";
        ".config/nvim/lua/settings".source = mkOutOfStoreSymlink
          "${modFolder}/config/lua/settings";
      };
      shellAliases = {
        "nano" = "nvim";
        "nv" = "nvim";
      };
    };
    programs.neovim = mkMerge [
      {
        inherit (cfg) enable extraLuaConfig;
        defaultEditor = true;
        extraPackages = with pkgs; [ fd ripgrep tree-sitter ];
        plugins = with pkgs.vimPlugins; [
          {
            plugin = bufferline-nvim;
            type = "lua";
            config = ''
              require "settings.bufferline"
            '';
          }
          cmp-cmdline
          cmp-buffer
          cmp-nerdfont
          cmp-nvim-lsp
          cmp-nvim-ultisnips
          cmp-path
          cmp-rg
          {
            plugin = comment-nvim;
            type = "lua";
            config = ''
              require('Comment').setup()
            '';
          }
          {
            plugin = gitsigns-nvim;
            type = "lua";
            config = ''
              require "settings.git"
            '';
          }
          {
            plugin = indent-blankline-nvim;
            type = "lua";
            config = ''
              require "settings.indent-blankline"
            '';
          }
          {
            plugin = leap-nvim;
            type = "lua";
            config = ''
              require("leap").add_default_mappings()
            '';
          }
          {
            plugin = lualine-nvim;
            type = "lua";
            config = ''
              require "settings.lualine"
            '';
          }
          {
            plugin = mini-nvim;
            type = "lua";
            config = ''
              require("mini.animate").setup()
            '';
          }
          {
            plugin = noice-nvim;
            type = "lua";
            config = ''
              require "settings.noice"
            '';
          }
          nui-nvim
          {
            plugin = nvim-autopairs;
            type = "lua";
            config = ''
              require "settings.autopairs"
            '';
          }
          {
            plugin = nvim-cmp;
            type = "lua";
            config = ''
              require "settings.cmp"
            '';
          }
          nvim-notify
          {
            plugin = nvim-surround;
            type = "lua";
            config = ''
              require("nvim-surround").setup()
            '';
          }
          {
            plugin = nvim-tree-lua;
            type = "lua";
            config = ''
              require "settings.nvim-tree"
            '';
          }
          {
            plugin = nvim-treesitter.withAllGrammars;
            type = "lua";
            config = ''
              require "settings.treesitter"
            '';
          }
          nvim-ts-rainbow2
          {
            plugin = nvim-undotree;
            type = "lua";
            config = ''
              require "settings.undotree"
            '';
          }
          {
            plugin = nvim-ufo;
            type = "lua";
            config = ''
              -- require "settings.ufo"
            '';
          }
          nvim-web-devicons
          {
            plugin = oil-nvim;
            type = "lua";
            config = ''
              require('oil').setup()
              vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
            '';
          }
          plenary-nvim
          promise-async
          repeat
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
          vim-highlightedyank
          vim-illuminate
          {
            plugin = which-key-nvim;
            type = "lua";
            config = ''
              require "settings.which-key"
            '';
          }
        ];
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        withNodeJs = true;
        withRuby = false;
      }
      (mkIf cfg.enableLSP {
        extraPackages = let
          my-python = inputs.unstable.legacyPackages.${pkgs.system}.python3.withPackages (py:
            with py; [
              black
              flake8
              pylsp-rope
              python-lsp-server
              (mkIf cfg.qtile (qtile qtile-extras))
            ]);
        in (with pkgs; [
          efm-langserver
          lua-language-server
          nil
          nixfmt
          my-python
          statix
          stylua
        ]) ++ (with pkgs.luaPackages; [ luacheck ]);
        plugins = with pkgs.vimPlugins; [
          efmls-configs-nvim
          neodev-nvim
          {
            plugin = nvim-lspconfig;
            type = "lua";
            config = ''
              require "settings.lspconfig"
            '';
          }
        ];
      })
    ];
  };
}

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
        dressing-nvim
        {
          plugin = gitsigns-nvim;
          type = "lua";
          config = ''
            require "settings.git"
          '';
        }
        {
          plugin = hop-nvim;
          type = "lua";
          config = ''
            require "settings.hop"
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
        {
          plugin = nvim-lspconfig;
          type = "lua";
          config = ''
            require "settings.lspconfig"
          '';
        }
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
      ]);
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
      withRuby = false;
    };
  };
}

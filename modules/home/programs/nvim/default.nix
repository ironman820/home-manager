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
    # ironman.home.build-utils = enabled;
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
      plugins = with pkgs.vimPlugins; [
      #   {
      #     plugin = bufferline-nvim;
      #     type = "lua";
      #     config = ''
      #       require "settings.bufferline"
      #     '';
      #   }
      #   comment-nvim
      #   {
      #     plugin = dressing-nvim;
      #     type = "lua";
      #     config = ''
      #       require "settings.dressing"
      #     '';
      #   }
      #   {
      #     plugin = gitsigns-nvim;
      #     type = "lua";
      #     config = ''
      #       require "settings.git"
      #     '';
      #   }
      #   {
      #     plugin = hop-nvim;
      #     type = "lua";
      #     config = ''
      #       require "settings.hop"
      #     '';
      #   }
      #   {
      #     plugin = indent-blankline-nvim;
      #     type = "lua";
      #     config = ''
      #       require "settings.indentline"
      #     '';
      #   }
      #   {
      #     plugin = lualine-nvim;
      #     type = "lua";
      #     config = ''
      #       require "settings.lualine"
      #     '';
      #   }
      #   {
      #     plugin = mini-nvim;
      #     type = "lua";
      #     config = ''
      #       require("mini.animate").setup()
      #     '';
      #   }
      #   {
      #     plugin = nvim-autopairs;
      #     type = "lua";
      #     config = ''
      #       require "settings.autopairs"
      #     '';
      #   }
      #   {
      #     plugin = nvim-surround;
      #     type = "lua";
      #     config = ''
      #       require("nvim-surround").setup()
      #     '';
      #   }
      #   {
      #     plugin = nvim-tree-lua;
      #     type = "lua";
      #     config = ''
      #       require "settings.nvim-tree"
      #     '';
      #   }
      #   {
      #     plugin = nvim-treesitter.withAllGrammars;
      #     type = "lua";
      #     config = ''
      #       require "settings.treesitter"
      #     '';
      #   }
      #   nvim-ts-rainbow2
      #   nvim-web-devicons
      #   plenary-nvim
      #   {
      #     plugin = telescope-nvim;
      #     type = "lua";
      #     config = ''
      #       require "settings.telescope"
      #     '';
      #   }
        {
          plugin = tokyonight-nvim;
          type = "lua";
          config = ''
            require "settings.colors"
          '';
        }
      #   {
      #     plugin = pkgs.ironman.nvim-undotree;
      #     type = "lua";
      #     config = ''
      #       require "settings.undotree"
      #     '';
      #   }
      #   {
      #     plugin = which-key-nvim;
      #     type = "lua";
      #     config = ''
      #       require "settings.whichkey"
      #     '';
      #   }
      ];
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };
    #   (mkIf cfg.enableLSP {
    #     extraPackages = with pkgs; [
    #       cargo
    #       fd
    #       go
    #       julia
    #       luarocks
    #       (python3.withPackages (py: with py; [
    #         black
    #         debugpy
    #         isort
    #         pip
    #         pylama
    #         setuptools
    #         yamllint
    #       ]))
    #       tree-sitter
    #       unzip
    #       wl-clipboard
    #     ];
    #     plugins = (with pkgs.vimPlugins; [
    #       cmp-buffer
    #       cmp_luasnip
    #       cmp-nvim-lsp
    #       cmp-nvim-lua
    #       cmp-rg
    #       friendly-snippets
    #       lsp-inlayhints-nvim
    #       luasnip
    #       {
    #         plugin = nvim-cmp;
    #         type = "lua";
    #         config = ''
    #           require "settings.lsp_cmp"
    #         '';
    #       }
    #       (let
    #         lspServers = pkgs.writeText "lsp_servers.json" (builtins.toJSON (import ./lsp_servers.nix { inherit pkgs; }));
    #       in {
    #         plugin = nvim-lspconfig;
    #         type = "lua";
    #         config = ''
    #           require("settings.lsp").setup_servers("${lspServers}")
    #           require "settings.lsp_cmp"
    #         '';
    #       })
    #     ]) ++ (with inputs.unstable.legacyPackages.${pkgs.system}.vimPlugins; [
    #       # cmp-async-path
    #     ]) ++ (with pkgs.ironman; [
    #       # cmp-nerdfont
    #       {
    #         plugin = lsp-zero-nvim;
    #         type = "lua";
    #         config = ''
    #           require "settings.language"
    #         '';
    #       }
    #     ]);
    #   })
    # ];
  };
}

return {
  -- Auto Pairs
  {
    "windwp/nvim-autopairs",
  },
  -- Bufferline Extension
  {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons"
  },
  -- Cellular Automaton
  {
    "eandrju/cellular-automaton.nvim",
  },
  -- Color Scheme
  {
    -- "folke/tokyonight.nvim",
    -- opts = {},
    -- "lunarvim/synthwave84.nvim",
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
  },
  -- Dressing
  {
    "stevearc/dressing.nvim",
    lazy = true,
  },
  -- Git Integration
  {
    "lewis6991/gitsigns.nvim",
  },
  -- Hop
  {
    "phaazon/hop.nvim",
    lazy = true,
  },
  -- Indent Highlighting
  {
    "lukas-reineke/indent-blankline.nvim",
  },
  -- LSP Config
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    dependencies = {
      -- LSP Support
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      -- Autocompletion
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "FelipeLema/cmp-async-path",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lua",
      "chrisgrieser/cmp-nerdfont",
      "lukas-reineke/cmp-rg",
      -- Snippets
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "lvimuser/lsp-inlayhints.nvim",
    },
  },
  -- Lualine Extension
  {
    "nvim-lualine/lualine.nvim",
    dependencies = "nvim-tree/nvim-web-devicons"
  },
  -- Mini.Nvim
  {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
      require("mini.animate").setup()
    end
  },
  -- Nvim-Surround
  {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup({})
    end
  },
  -- Nvimtree
  {
    "nvim-tree/nvim-tree.lua",
    lazy = true,
    dependencies = "nvim-tree/nvim-web-devicons",
  },
  -- Rainbow Highlighting
  {
    "HiPhish/nvim-ts-rainbow2",
  },
  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    dependencies = "nvim-lua/plenary.nvim",
  },
  -- Toggle Term
  {
    "akinsho/toggleterm.nvim",
  },
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = "luckasRanarison/tree-sitter-hypr",
  },
  -- Undo-Tree
  {
    "jiaoshijie/undotree",
    dependencies = "nvim-lua/plenary.nvim",
  },
  -- Which-key Extension
  {
    "folke/which-key.nvim",
    lazy = true,
  }
}
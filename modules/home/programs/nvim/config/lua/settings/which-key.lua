local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  return
end

local setup = {
  plugins = {
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    presets = {
      operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = true, -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  -- operators = { gc = "Comments" },
  key_labels = {
    -- override the label used to display some keys. It doesn't effect WK in any other way.
    -- For example:
    -- ["<space>"] = "SPC",
    -- ["<cr>"] = "RET",
    -- ["<tab>"] = "TAB",
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  },
  popup_mappings = {
    scroll_down = "<c-j>", -- binding to scroll down inside the popup
    scroll_up = "<c-k>", -- binding to scroll up inside the popup
  },
  window = {
    border = "rounded", -- none, single, double, shadow
    position = "bottom", -- bottom, top
    margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
    winblend = 0,
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = "left", -- align columns left, center or right
  },
  ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
  show_help = true, -- show help message on the command line when the popup is visible
  triggers = "auto", -- automatically setup triggers
  -- triggers = {"<leader>"} -- or specify a list manually
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    i = { "j", "k" },
    v = { "j", "k" },
  },
}

local opts = {
  mode = "n", -- NORMAL mode
  prefix = "<leader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
  b = {
    name = "[B]uffer",
    c = { "<cmd>bd<cr>", "[C]lose" },
    n = { "<cmd>new<cr>", "[N]ew" },
    s = { "<cmd>w<cr>", "[S]ave" },
  },
  e = { "<cmd>NvimTreeFocus<cr>", "Explorer" },
  f = {
    name = "[F]ind",
  },
  g = { name = "[G]oto" },
  l = {
    name = "[L]SP",
    c = { name = "[C]ode" },
    w = { name = "[W]orkspace" },
  --   a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
  --   i = { "<cmd>LspInfo<cr>", "Info" },
  --   l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
  --   r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
  --   s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
  --   S = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols" },
  },
  u = { "<cmd>lua require('undotree').toggle()<cr>", "[U]ndo Tree" },
  w = {
    name = "[W]indow",
    c = { "<C-w>c", "[C]lose window"},
    h = { "<C-w>h", "Move to left window" },
    j = { "<C-w>j", "Move to lower window" },
    k = { "<C-w>k", "Move to upper window" },
    l = { "<C-w>l", "Move to right window" },
    o = { "<C-w>o", "Close [O]ther windows"},
    q = { "<cmd>wqa!<CR>", "[Q]uit, saving open files"},
    s = {
      name = "[S]plit",
      h = { "<cmd>split<cr>", "[H]orizontally" },
      v = { "<cmd>vsplit<cr>", "[V]ertically" },
    },
  },
}

which_key.setup(setup)
which_key.register(mappings, opts)

require("neodev").setup({})

-- Setup language servers
local lspconfig = require("lspconfig")

local signs = { Error = " ", Warn = " ", Hint = "", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()
local opts = {
  capabilities = capabilities,
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.stdpath("config") .. "/lua"] = true,
        },
      },
    },
  },
}
lspconfig.lua_ls.setup(opts)
opts.settings = nil
lspconfig.nil_ls.setup(opts)
lspconfig.pylsp.setup(opts)

local luacheck = require("efmls-configs.linters.luacheck")
local stylua = require("efmls-configs.formatters.stylua")
local statix = require("efmls-configs.linters.statix")
local nixfmt = require("efmls-configs.formatters.nixfmt")
-- local flake8 = require("efmls-configs.linters.flake8")
local black = require("efmls-configs.formatters.black")

opts = {
  capabilities = capabilities,
  filetypes = {
    "lua",
    "nix",
    "python",
  },
  init_options = {
    documentFormatting = true,
    documentRangeFormatting = true,
    hover = true,
    documentSymbol = true,
    codeAction = true,
    completion = true,
  },
  settings = {
    languages = {
      lua = { luacheck, stylua },
      nix = { statix, nixfmt },
      -- python = { flake8, black },
      python = { black },
    },
  },
}

lspconfig.efm.setup(opts)

opts = nil

local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", {})
vim.api.nvim_create_autocmd("BufWritePost", {
  group = lsp_fmt_group,
  callback = function()
    local efm = vim.lsp.get_active_clients({ name = "efm" })
    if vim.tbl_isempty(efm) then
      return
    end
    vim.lsp.buf.format({ name = "efm" })
  end,
})

-- Diagnostics keymapping
vim.keymap.set("n", "<leader>le", vim.diagnostic.open_float, { desc = "Float diagnostics window" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous [D]iagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next [D]iagnostic" })
vim.keymap.set("n", "<leader>lq", vim.diagnostic.setloclist, { desc = "Open Diagnostic list." })

-- LSP Attach autocommand settings
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- enable completion <C-x><C-o> default keys
    -- vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Buffer mappings
    local buf = vim.lsp.buf
    opts = {
      buffer = ev.buf,
      desc = "Goto [D]eclaration",
    }
    local keys = vim.keymap
    keys.set("n", "gD", buf.declaration, opts)
    opts.desc = "Goto [D]efinition"
    keys.set("n", "gd", buf.definition, opts)
    opts.desc = nil
    keys.set("n", "K", buf.hover, opts)
    opts.desc = "Goto [I]mplementation"
    keys.set("n", "gi", buf.implementation, opts)
    opts.desc = nil
    keys.set("n", "<C-k>", buf.signature_help, opts)
    opts.desc = "[A]dd folder to workspace"
    keys.set("n", "<leader>lwa", buf.add_workspace_folder, opts)
    opts.desc = "[R]emove workspace folder"
    keys.set("n", "<leader>lwr", buf.remove_workspace_folder, opts)
    opts.desc = "[L]ist workspace folders"
    keys.set("n", "<leader>lwl", function()
      print(vim.inspect(buf.list_workspace_folders()))
    end, opts)
    opts.desc = "Goto type [D]efinition"
    keys.set("n", "<leader>lD", buf.type_definition, opts)
    opts.desc = "[R]ename"
    keys.set("n", "<leader>lrn", buf.rename, opts)
    opts.desc = "[A]ctions"
    keys.set({ "n", "v" }, "<leader>lca", buf.code_action, opts)
    opts.desc = "Goto [R]eferences"
    keys.set("n", "gr", buf.references, opts)
    opts.desc = "[F]ormat"
    keys.set("n", "<leader>lf", function()
      buf.format({ async = true })
    end, opts)
    opts.desc = "[I]nfo"
    keys.set("n", "<leader>li", "<Cmd>LspInfo<Cr>", opts)
  end,
})


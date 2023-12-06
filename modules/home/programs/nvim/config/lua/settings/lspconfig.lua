-- vim.lsp.set_log_level("debug")

local ok, neodev = pcall(require, "neodev")
if ok then
  neodev.setup({})
end

-- Setup language servers
local lspconfig = require("lspconfig")

local signs = { Error = " ", Warn = " ", Hint = "", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local keys = vim.keymap
local buffer = vim.lsp.buf
local opts = {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    keys.set("n", "K", buffer.hover, { desc = "Enable hover definitions" })
    keys.set("n", "gd", buffer.definition, { desc = "Goto Definition" })
    keys.set("n", "gi", buffer.implementation, { desc = "Goto Implimentation" })
    keys.set("n", "<leader>ld", "<cmd>Telescope diagnostics<cr>", { desc = "Open Diagnostics list" })
    keys.set("n", "<leader>li", "<Cmd>LspInfo<CR>", { desc = "Open LSP [I]nfo" })
    keys.set("n", "<leader>ll", "<cmd>LspLog<cr>", { desc = "Open LSP [L]og" })
    if client.server_capabilities["documentSymbolProvider"] then
      require("nvim-navic").attach(client, bufnr)
    end
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
  end,
  flags = {
    debounce_text_changes = 500,
  },
  settings = {},
}
opts['settings']['Lua'] = {
  completion = {
    callSnippet = "Replace",
  },
  workspace = {
    checkThirdParty = false,
    library = {
      [vim.fn.expand("$VIMRUNTIME/lua")] = true,
      [vim.fn.stdpath("config") .. "/lua"] = true,
      -- ["${3rd}/luv/library"] = true,
    },
  },
}
lspconfig.lua_ls.setup(opts)
opts['settings']['Lua'] = nil
lspconfig.nil_ls.setup(opts)
-- local handle = io.popen("realpath $(which python3)")
-- if handle ~= nil then
--   print("loading path")
--   local result = handle:read("*a")
--   handle:close()
--   print(result)
--   opts['settings']['pyright'] = {
--     venvPath = result,
--   }
-- end
lspconfig.pyright.setup(opts)
lspconfig.phpactor.setup(opts)

-- PyrightSetPythonPath(result)

local luacheck = require("efmls-configs.linters.luacheck")
local stylua = require("efmls-configs.formatters.stylua")
local statix = require("efmls-configs.linters.statix")
local nixfmt = require("efmls-configs.formatters.nixfmt")
local flake8 = require("efmls-configs.linters.flake8")
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
      python = { flake8, black },
    },
  },
}

lspconfig.efm.setup(opts)

-- Diagnostics keymapping
vim.keymap.set("n", "<leader>le", vim.diagnostic.open_float, { desc = "Float diagnostics window" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous [D]iagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next [D]iagnostic" })

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("lazy").setup("plugins", {
  dev = {
    path = "~/.local/share/nvim/nix",
    fallback = false,
  }
})
-- require("lazy").setup({
--   spec = {
--     {
--       "abeldekat/lazyflex.nvim",
--       version = "*",
--       cond = true,
--       import = "lazyflex.hook",
--       opts = { enable_match = false, kw = { "barbe", "navic", "neodev", "ufo", "promise", "which", "undo", "cmp", "lsp", "snip", "efm", "fidg", "treesit", "rainbow", "hop", "tele", "plen", "git" } },
--     },
--     { import = "plugins" },
--   },
-- })

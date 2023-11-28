local opt = vim.opt

opt.mouse = "" -- disable mouse mode
opt.wrap = true -- Line wrap
opt.shortmess:append("WIcC")

require("mini.basics").setup({
  options = {
    basic = true,
    extra_ui = true,
    win_borders = "single",
  },
  mappings = {
    basic = true,
    option_toggle_prefix = [[\]],
    windows = true,
    move_with_alt = false,
  },
  autocommands = {
    basic = true,
    relnum_in_visual_mode = false,
  },
  silent = false,
})

opt.autochdir = false
opt.autowrite = true -- Enable auto write
opt.backspace = "indent,eol,start"
opt.clipboard:append("unnamedplus") -- Sync with system clipboard
opt.cmdheight = 1
opt.conceallevel = 2 -- Hide * markup for bold and italic
opt.concealcursor = "nc" -- Hide * markup for bold and italic
opt.colorcolumn = "100"
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.encoding = "UTF-8"
opt.errorbells = false
opt.expandtab = true -- Use spaces instead of tabs
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.guicursor =
  "n-v-c:block,i-ci-ve:ver20,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"
opt.hidden = true
opt.hlsearch = false
opt.inccommand = "nosplit" -- preview incremental substitute
opt.iskeyword:append("-")
opt.laststatus = 0
opt.modifiable = true
opt.relativenumber = true -- Relative line numbers
opt.scrolloff = 10 -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.sidescrolloff = 8 -- Columns of context
opt.softtabstop = 2
opt.spelllang = { "en" }
opt.swapfile = false
opt.tabstop = 2 -- Number of spaces tabs count for
opt.timeoutlen = 500 -- speed must be under 500ms inorder for keys to work, increase if you are not able to.
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

local status_ok, gitsigns = pcall(require, "gitsigns")
if not status_ok then
  return
end

gitsigns.setup({
  signs = {
    add = { hl = "GitSignsAdd", text = "", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
    change = { hl = "GitSignsChange", text = "±", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    delete = { hl = "GitSignsDelete", text = "󰆴", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    topdelete = { hl = "GitSignsDelete", text = "※", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    changedelete = { hl = "GitSignsChange", text = "▲", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
  },
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 1000,
    follow_files = true,
  },
  attach_to_untracked = true,
  current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter_opts = {
    relative_time = false,
  },
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000,
  preview_config = {
    -- Options passed to nvim_open_win
    border = "single",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
  yadm = {
    enable = false,
  },
})

local keys = vim.keymap
keys.set("n", "<leader>gpf", "<Cmd>Git push --force<Cr><C-W>_", { desc = "Git [P]ush [F]orce" })
keys.set("n", "<leader>gg", "<Cmd>LazyGit<Cr>", { desc = "Open Lazy[G]it" })
keys.set("n", "<leader>gl", "<Cmd>Git log<Cr><C-W>_", { desc = "Open Git [L]og" })
keys.set("n", "<leader>go", "<Cmd>Neogit<Cr>", { desc = "[O]pen Git View" })
keys.set("n", "<leader>gpl", "<Cmd>Git pull<Cr><C-W>_", { desc = "Git [P]u[l]l" })
keys.set("n", "<leader>gpr", "<Cmd>Git pull --rebase<Cr><C-W>_", { desc = "Git [P]ull [R]ebase" })
keys.set("n", "<leader>gps", "<Cmd>Git push<Cr><C-W>_", { desc = "Git [P]u[s]h" })
keys.set("n", "<leader>grb", "ri", { desc = "Git Re[b]ase" })
keys.set("n", "<leader>grv", "crn", { desc = "Git Re[v]ert" })

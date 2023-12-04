local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

local actions = require('telescope.actions')

telescope.setup({
  defaults = {
    prompt_prefix = " ",
    selection_caret = " ",
    path_display = { "truncate" },

    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
    },
  },
  pickers = {
    buffers = {
      theme = "dropdown",
    },
    builtin = {
      theme = "dropdown",
    },
    commands = {
      theme = "dropdown",
    },
    find_files = {
      theme = "dropdown",
    },
    live_grep = {
      theme = "dropdown",
    },
  }
})
telescope.load_extension('fzf')
telescope.load_extension('dap')

local builtin = require('telescope.builtin')
local keys = vim.keymap

keys.set('n', '<leader>fb', builtin.buffers, { desc = "[B]uffers" })
keys.set('n', '<leader>fc', builtin.commands, { desc = "[C]ommands" })
keys.set('n', '<leader>ff', builtin.find_files, { desc = "[F]iles" })
keys.set('n', '<leader>fg', builtin.live_grep, { desc = "[G]rep" })
keys.set('n', '<leader>fh', builtin.help_tags, { desc = "[H]elp" })
keys.set('n', '<leader>fk', builtin.keymaps, { desc = "[K]eymaps" })
keys.set('n', '<leader>fp', builtin.builtin, { desc = "[P]ickers" })
keys.set('n', '<leader>fr', builtin.oldfiles, { desc = "[R]ecent files" })
keys.set('n', '<leader>gb', builtin.git_branches, { desc = "[B]ranches" })
keys.set('n', '<leader>gc', builtin.git_commits, { desc = "[C]ommits" })

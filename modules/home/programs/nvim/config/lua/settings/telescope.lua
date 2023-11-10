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

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "[B]uffers" })
vim.keymap.set('n', '<leader>fc', builtin.commands, { desc = "[C]ommands" })
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "[F]iles" })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "[G]rep" })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "[H]elp" })
vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = "[K]eymaps" })
vim.keymap.set('n', '<leader>fp', builtin.builtin, { desc = "[P]ickers" })
vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = "[R]ecent files" })


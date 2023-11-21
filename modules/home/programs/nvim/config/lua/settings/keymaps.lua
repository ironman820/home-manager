local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

keymap("", "q", "<Nop>", opts)

keymap("n", "<leader>p", "<Cmd>Lazy<cr>", { desc = "[P]lugin Manager" })

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- navigate buffers
keymap("n", "<Tab>", "<cmd>bnext<cr>", opts) -- Next Tab
keymap("n", "<s-tab>", "<cmd>bprevious<cr>", opts) -- Previous tab

-- insert --
-- press jk fast to exit insert mode
keymap("i", "jk", "<esc>", opts) -- Insert mode -> jk -> Normal mode
keymap("i", "kj", "<esc>", opts) -- Insert mode -> kj -> Normal mode

-- visual --
-- stay in indent mode
keymap("v", "<", "<gv", opts) -- Right Indentation
keymap("v", ">", ">gv", opts) -- Left Indentation

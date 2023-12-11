local trouble = require("trouble")
trouble.setup({
  auto_open = true,
  auto_close = true,
})

local keys = vim.keymap

keys.set("n", "<leader>lt", trouble.toggle, { desc = "[T]oggle Trouble list" })

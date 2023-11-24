vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

local keys = vim.keymap
-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
keys.set('n', 'zR', require('ufo').openAllFolds)
keys.set('n', 'zM', require('ufo').closeAllFolds)
keys.set('n', '<Leader>-', '<Cmd>set foldlevel-=1<CR>zz', { desc = "zoom out (see less)", })
keys.set('n', '<Leader>=', '<Cmd>set foldlevel+=1<CR>zz', { desc = "zoom in (see more)", })
keys.set('n', '<Leader><Leader>-', '<Cmd>set foldlevel=0<CR>zM', { desc = "zoom out max", })
keys.set('n', '<Leader><Leader>=', '<Cmd>set foldlevel=20<CR>zR', { desc = "zoom in max", })
keys.set('n', 'Z', 'zkzxzz', {})
keys.set('n', 'X', 'zjzxzz', {})

require("ufo").setup({provider_selector = function(_, _, _)
    return {'treesitter', 'indent'}
end})

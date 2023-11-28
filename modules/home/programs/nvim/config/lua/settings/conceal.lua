local conceal = require("conceal")

-- should be run before .generate_conceals to use user Configuration
conceal.setup({
  ["lua"] = {
    keywords = {
      ["function"] = {
        conceal = "󰊕",
      },
      ["local"] = {
        enabled = false,
      },
      ["require"] = {
        conceal = "rq",
      },
    },
  },
  ["python"] = {
    keywords = {
      ["def"] = {
        conceal = "󰊕",
      },
      ["import"] = {
        conceal  = "󰶮",
      },
    },
  },
})

-- generate the scm queries
-- only need to be run when the Configuration changes
conceal.generate_conceals()

-- bind a <leader>tc to toggle the concealing level
vim.keymap.set("n", "\\z", function()
  require("conceal").toggle_conceal()
end, { silent = true, desc = "Toggle 'conceal'" })


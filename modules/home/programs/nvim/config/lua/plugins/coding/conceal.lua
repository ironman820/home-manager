local conceal = require("conceal")

conceal.setup({
  ["lua"] = {
    enabled = true,
    keywords = {
      ["and"] = {
        conceal = "󰪍",
      },
      ["end"] = {
        conceal = "",
      },
      ["function"] = {
        conceal = "󰊕",
      },
      ["if"] = {
        conceal = "",
      },
      ["local"] = {
        conceal = "󰼈",
      },
      ["not"] = {
        conceal = "󰈅",
      },
      ["require"] = {
        conceal = "",
      },
      ["return"] = {
        conceal = "󱞴",
      },
    },
  },
})

conceal.generate_conceals()

local map = require("user-util").map
map("<leader>uc", conceal.toggle_conceal, { desc = "Toggle Conceal", mode = "n", silent = true })

local dap = require("dap")
local keys = vim.keymap

require("dap-python").setup()

keys.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle [B]reakpoint" })
keys.set("n", "<leader>dc", dap.continue, { desc = "[C]ontinue debugging" })
keys.set("n", "<leader>dr", dap.repl.open, { desc = "[R]epl" })
keys.set("n", "<leader>dsi", dap.step_into, { desc = "Step [I]nto" })
keys.set("n", "<leader>dso", dap.step_out, { desc = "Step [O]ut" })
keys.set("n", "<leader>dsp", dap.step_over, { desc = "Step [P]ast" })

local dapui = require("dapui")
dapui.setup()
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.after.event_exited["dapui_config"] = function()
  dapui.close()
end
dap.listeners.after.event_terminated["dapui_config"] = function()
  dapui.close()
end

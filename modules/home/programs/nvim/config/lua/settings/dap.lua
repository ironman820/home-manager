local dap = require("dap")
local keys = vim.keymap
keys.amend = require("keymap-amend")

require("dap-python").setup()

keys.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle [B]reakpoint" })
keys.set("n", "<leader>dc", dap.continue, { desc = "[C]ontinue debugging" })
keys.set("n", "<leader>dr", dap.repl.open, { desc = "[R]epl" })
keys.set("n", "<leader>b", function(original)
  if dap.status() == "" then
    original()
  else
    dap.toggle_breakpoint()
  end
end, { desc = "Toggle [B]reakpoint" })
keys.amend("n", "<leader>c", function(original)
  if dap.status() == "" then
    original()
  else
    dap.continue()
  end
end, { desc = "[C]ontinue debugging" })
keys.set("n", "<leader>i", function(original)
  if dap.status() == "" then
    original()
  else
    dap.step_into()
  end
end, { desc = "Step [I]nto" })
keys.set("n", "<leader>o", function(original)
  if dap.status() == "" then
    original()
  else
    dap.step_out()
  end
end, { desc = "Step [O]ut" })
keys.set("n", "<leader>p", function(original)
  if dap.status() == "" then
    original()
  else
    dap.step_over()
  end
end, { desc = "Step [P]ast" })
keys.set("n", "<leader>t", function(original)
  if dap.status() == "" then
    original()
  else
    dap.terminate()
  end
end, { desc = "[T]erminate" })

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

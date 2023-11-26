vim.cmd([[
  " Write all buffers before navigating from Vim to tmux pane
  let g:tmux_navigator_save_on_switch = 1
  " Disable tmux navigator when zooming the Vim pane
  let g:tmux_navigator_disable_when_zoomed = 1
  " If the tmux window is zoomed, keep it zoomed when moving from Vim to another pane
  let g:tmux_navigator_preserve_zoom = 1
]])

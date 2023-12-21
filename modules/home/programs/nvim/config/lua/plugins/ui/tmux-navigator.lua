local tmux_nav_ok, tmux_nav = pcall(require, "vim-tmux-navigator")
if not tmux_nav_ok then
  return
end
tmux_nav.setup({
  disabled_when_zoomed = true,
})

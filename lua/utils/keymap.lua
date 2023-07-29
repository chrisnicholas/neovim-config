local M = {}

-- Set keymap
M.map = function(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true })
end

-- Normal mode keymap
M.nmap = function(shortcut, command)
  M.map("n", shortcut, command)
end

return M

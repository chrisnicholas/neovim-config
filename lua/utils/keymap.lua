local M = {}

-- Set keymap
M.map = function(mode, l, r, opts)
  opts = opts or {}
  vim.keymap.set(mode, l, r, opts)
end

-- Normal mode keymap
function M.nmap(shortcut, command, opts)
  M.map("n", shortcut, command, opts)
end

return M

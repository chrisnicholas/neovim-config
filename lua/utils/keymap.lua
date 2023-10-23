local M = {}

-- Set keymap
function M.map(mode, shortcut, command, opts)
  opts = vim.tbl_deep_extend('force', opts or {}, { noremap = true })
  vim.api.nvim_set_keymap(mode, shortcut, command, opts)
end

-- Normal mode keymap
function M.nmap(shortcut, command, opts)
  M.map("n", shortcut, command, opts)
end

return M

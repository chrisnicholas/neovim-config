local M = {
  'catppuccin/nvim',
  name = 'catppuccin',
  lazy = true,
  priority = 1000,
}

M.opts = {
  flavor = 'frappe',
}

function M.config(_, opts)
  local catppuccin = require('catppuccin')
  catppuccin.setup(opts)

  vim.cmd.colorscheme('catppuccin')
end

return M

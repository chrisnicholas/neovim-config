local M = {
  'folke/tokyonight.nvim',
  lazy = true,
  priority = 1000,
}

M.opts = {
  style = 'moon',
  transparent = false
}

function M.config(_, opts)
  local tokyonight = require('tokyonight')
  tokyonight.setup(opts)
  tokyonight.load()
end

return M

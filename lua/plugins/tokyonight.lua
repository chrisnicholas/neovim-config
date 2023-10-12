local M = {}

function M.init()
  return {
    'folke/tokyonight.nvim',
    lazy = true,
    priority = 1000,
    opts = M.opts,
    config = M.config
  }
end

function M.opts()
  return {
    style = 'moon',
    transparent = false
  }
end

function M.config(_, opts)
  local tokyonight = require('tokyonight')
  tokyonight.setup(opts)
  tokyonight.load()
end

return M.init()

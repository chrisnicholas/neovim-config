local M = {}

function M.init()
  return {
    'nvim-tree/nvim-tree.lua',
    requires = { 'nvim-tree/nvim-web-devicons' },
    config = M.config
  }
end

function M.config()
  require('nvim-tree').setup()
end

return M.init()

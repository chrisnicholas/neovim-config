local M = {}

function M.init()
  return {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
end

return M.init()

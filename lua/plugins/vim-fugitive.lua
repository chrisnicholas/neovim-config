local M = {}

function M.init()
  return {
    'tpope/vim-fugitive',
    event = 'BufReadPre'
  }
end

return M.init()

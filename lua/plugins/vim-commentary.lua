local M = {}

function M.init()
  return {
    'tpope/vim-commentary',
    event = 'BufEnter'
  }
end

return M.init()

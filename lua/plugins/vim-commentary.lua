local M = {}

function M.init()
  return {
    'tpope/vim-commentary',
    event = 'BufReadPre'
  }
end

return M.init()

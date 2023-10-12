local M = {}

function M.init()
  return {
    'tpope/vim-rails',
    event = 'BufReadPre *.rb,*.erb'
  }
end

return M.init()

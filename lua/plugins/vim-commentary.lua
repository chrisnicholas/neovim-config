local M = {}

function M.init()
  return {
    'tpope/vim-commentary',
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  }
end

return M.init()

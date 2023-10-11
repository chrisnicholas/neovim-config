local M = {}

function M.init()
  return {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    config = M.config
  }
end

function M.config()
  require('lsp')
end

return M.init()

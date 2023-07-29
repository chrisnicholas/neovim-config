local M = {}

function M.init()
  return {
    'neovim/nvim-lspconfig',
    config = M.config
  }
end

function M.config()
  require('lsp')
end

return M.init()

local M = {}

function M.init(on_attach)
  require('lspconfig').tsserver.setup{
    on_attach = on_attach,
  }
end

return M

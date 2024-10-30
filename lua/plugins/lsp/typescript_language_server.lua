local M = {}

function M.init(on_attach)
  require('lspconfig').ts_ls.setup{
    on_attach = on_attach,
  }
end

return M

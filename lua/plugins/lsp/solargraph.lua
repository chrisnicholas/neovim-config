local M = {}

function M.init(on_attach)
  require('lspconfig').solargraph.setup{
    on_attach = on_attach,
    settings = {
      solargraph = {
        diagnostics = false
      }
    }
  }
end

return M

local M = {}

function M.init(on_attach, capabilities)
  require('lspconfig').solargraph.setup{
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      solargraph = {
        diagnostics = true
      }
    }
  }
end

return M

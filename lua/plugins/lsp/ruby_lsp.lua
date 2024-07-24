local M = {}

function M.init(on_attach, capabilities)
  require('lspconfig').ruby_lsp.setup{
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      ruby_lsp = {}
    }
  }
end

return M

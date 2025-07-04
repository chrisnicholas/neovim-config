local M = {}

function M.init(on_attach, capabilities)
  require('lspconfig').rust_analyzer.setup{
    on_attach = on_attach,
    capabilities = capabilities
  }

  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.rs",
    callback = M.rustfmt
  })
end

-- Run rustfmt on save
function M.rustfmt()
  vim.lsp.buf.format({ async = false })
end

return M

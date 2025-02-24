local M = {}

function M.init(on_attach, capabilities)
  require('lspconfig').terraformls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
  vim.api.nvim_create_autocmd({"BufWritePre"}, {
    pattern = {"*.tf", "*.tfvars"},
    callback = function()
      vim.lsp.buf.format()
    end,
  })
end

return M

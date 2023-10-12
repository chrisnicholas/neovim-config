local M = {}

function M.init(on_attach)
  -- Go
  require('lspconfig').gopls.setup{
    on_attach = on_attach
  }

  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = M.goimports
  })

  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = M.gofmt
  })
end

-- Run goimports on save
function M.goimports()
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { "source.organizeImports" } }

  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)

  for client_id, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        local encoding = (vim.lsp.get_client_by_id(client_id) or {}).offset_encoding or "utf-16"
        vim.lsp.util.apply_workspace_edit(r.edit, encoding)
      end
    end
  end
end

-- Run gofmt on save
function M.gofmt()
  vim.lsp.buf.format({ async = false })
end

return M

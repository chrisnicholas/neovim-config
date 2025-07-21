--- gopls configuration
---
--- Reference:
--- - https://github.com/golang/vscode-go/wiki/settings
--- - https://github.com/golang/tools/blob/master/gopls/doc/settings.md
---
---@type vim.lsp.ClientConfig
local Gopls = {
  settings = {
    gopls = {
      usePlaceholders = true,
      staticcheck = true,
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      codelenses = {
        generate = true,
        gc_details = true,
      },
      formatting = {
        gofumpt = true,
      },
      hoverKind = "FullDocumentation",
    },
  },
}

function Gopls.on_init(_client, _init_result)
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function(event)
      Gopls.goimports(event)
    end,
  })
end

function Gopls.goimports(event)
  local utils = require("lsp.utils")
  local client = vim.lsp.get_clients({ bufnr = event.buf, name = "gopls" })[1]
  local encoding = utils.get_client_encoding(client)
  local params = vim.lsp.util.make_range_params(0, encoding)
  params = vim.tbl_extend("force", params, { context = { only = { "source.organizeImports" } } })

  local result = vim.lsp.buf_request_sync(event.buf, "textDocument/codeAction", params, 1000)

  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, encoding)
      end
    end
  end
end

return Gopls

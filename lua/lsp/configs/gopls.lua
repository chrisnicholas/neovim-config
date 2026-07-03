--- gopls configuration
---
--- Reference:
--- - https://github.com/golang/vscode-go/wiki/settings
--- - https://github.com/golang/tools/blob/master/gopls/doc/settings.md
---
---@type vim.lsp.Config
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
    group = vim.api.nvim_create_augroup("gopls_goimports", { clear = true }),
    pattern = "*.go",
    callback = function(event)
      require("lsp.utils").goimports(event)
    end,
  })
end

return Gopls

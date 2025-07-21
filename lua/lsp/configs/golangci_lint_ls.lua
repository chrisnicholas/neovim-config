--- golangci-lint-langserver configuration
---
--- Reference:
--- - https://github.com/nametake/golangci-lint-langserver
---
---@type vim.lsp.ClientConfig
local GolangCILintLS = {
  init_options = {
    -- If you need to specify the golangci-lint binary, uncomment the line below.
    -- command = { "bin/golangci-lint", "run", "--out-format", "json" },
  }
}

return GolangCILintLS

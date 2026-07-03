--- TofuLS configuration
---
--- Reference:
--- - https://github.com/opentofu/tofu-ls/tree/main/docs
---
---@type vim.lsp.Config
local TofuLS = {
  filetypes = { "terraform", "terraform-vars", "opentofu", "opentofu-vars" }
}

return TofuLS

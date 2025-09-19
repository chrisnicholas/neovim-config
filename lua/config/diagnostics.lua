--- The Diagnostics module provides custom configuration and behavior for diagnostics.
---@class Diagnostics
local Diagnostics = {
  default_config = { virtual_lines = false, virtual_text = false }
}

---@param config? vim.diagnostic.Opts
function Diagnostics.init(config)
  config = vim.tbl_deep_extend("force", Diagnostics.default_config, config or {})

  vim.diagnostic.config(config)
end

return Diagnostics

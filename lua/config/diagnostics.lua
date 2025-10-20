--- The Diagnostics module provides custom configuration and behavior for diagnostics.
---@class Diagnostics
local Diagnostics = {
  default_config = { virtual_lines = false, virtual_text = false }
}

---@param config? vim.diagnostic.Opts
function Diagnostics.init(config)
  config = vim.tbl_deep_extend("force", Diagnostics.default_config, config or {})

  -- Set diagnostic sign priorities
  local sign_priorities = require('config.signs').priorities
  config.signs = {
    priority = sign_priorities.diagnostics,
  }

  vim.diagnostic.config(config)

  -- Filter diagnostics to show only highest severity per line
  -- Prevents sign column clutter when multiple diagnostics exist on same line
  local SIGNS_NS = vim.api.nvim_create_namespace("diagnostics_signs")
  local orig_signs_handler = vim.diagnostic.handlers.signs

  vim.diagnostic.handlers.signs = {
    show = function(_, bufnr, diagnostics, opts)
      -- Keep only highest severity diagnostic per line
      local severity_by_line = {}
      for _, d in ipairs(diagnostics) do
        local existing = severity_by_line[d.lnum]
        if not existing or d.severity < existing.severity then
          severity_by_line[d.lnum] = d
        end
      end

      local filtered = vim.tbl_values(severity_by_line)
      orig_signs_handler.show(SIGNS_NS, bufnr, filtered, opts)
    end,
    hide = function(_, bufnr)
      orig_signs_handler.hide(SIGNS_NS, bufnr)
    end,
  }
end

return Diagnostics

-- Sticky function/class headers. Uses the runtimepath parsers/queries and does
-- not depend on the nvim-treesitter core plugin.
---@type LazyPluginSpec
local M = {
  "nvim-treesitter/nvim-treesitter-context",
  event = "VeryLazy",
}

M.opts = { enable = true }

return M

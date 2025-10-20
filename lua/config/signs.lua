-- signcolumn priority configuration
-- Higher priority = shown first when multiple signs exist on same line
local M = {}

local dap = 20
local gitsigns = 10

M.priorities = {
  -- Debug Adapter Protocol signs (highest priority)
  dap = {
    breakpoint = dap,
    breakpoint_condition = dap,
    breakpoint_rejected = dap,
    stopped = dap,
  },

  -- Git signs
  gitsigns = {
    add = gitsigns,
    change = gitsigns,
    delete = gitsigns,
    topdelete = gitsigns,
    changedelete = gitsigns,
    untracked = gitsigns,
  },

  -- LSP diagnostic signs (lowest priority)
  diagnostics = 5,
}

return M

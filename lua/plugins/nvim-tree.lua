local M = {
  'nvim-tree/nvim-tree.lua',
  opts = {},
  enabled = false,
}

M.keys = {
  { "<leader>tf", ":NvimTreeToggle <cr>", desc = "Toggle NvimTree" },
}

return M

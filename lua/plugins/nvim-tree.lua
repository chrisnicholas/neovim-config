local M = {
  'nvim-tree/nvim-tree.lua',
  opts = {}
}

M.keys = {
  { "<leader>tf", ":NvimTreeToggle <cr>", desc = "Toggle NvimTree" },
}

return M

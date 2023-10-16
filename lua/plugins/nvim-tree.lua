local M = {
  'nvim-tree/nvim-tree.lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}

M.keys = {
  { "<leader>tf", ":NvimTreeToggle <cr>", desc = "Toggle NvimTree" },
}

function M.config()
  require('nvim-tree').setup()
end

return M

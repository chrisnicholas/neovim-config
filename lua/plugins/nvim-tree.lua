local M = {}

function M.init()
  return {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = M.keymaps,
    config = M.config
  }
end

function M.keymaps()
  return {
    { "<leader>tf", ":NvimTreeToggle <cr>", desc = "Toggle NvimTree"   },
  }
end

function M.config()
  require('nvim-tree').setup()
end

return M.init()

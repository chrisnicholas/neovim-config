local M = {}

function M.init()
  init_global_keymaps()

  return {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} },
    cmd = { 'Telescope' },
    config = M.config
  }
end

function M.config()
  require('telescope').setup()
end

function init_global_keymaps()
  local nmap = require('utils.keymap').nmap

  nmap("<leader>ff", ":Telescope find_files <cr>")
  nmap("<leader>fg", ":Telescope live_grep<cr>")
  nmap("<leader>fb", ":Telescope buffers<cr>")
  nmap("<leader>fh", ":Telescope help_tags<cr>")
end

return M.init()

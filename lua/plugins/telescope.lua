local M = {}

function M.init()
  return {
    'nvim-telescope/telescope.nvim',
    dependencies = { {'nvim-lua/plenary.nvim'} },
    cmd = { 'Telescope' },
    keys = M.keymaps,
    config = M.config
  }
end

function M.init_func()
  require("telescope").load_extension('notify')
end

function M.keymaps()
  return {
    { "<leader>ff", ":Telescope find_files <cr>", desc = "Find Files"           },
    { "<leader>fg", ":Telescope live_grep<cr>",   desc = "Live Grep"            },
    { "<leader>fb", ":Telescope buffers<cr>",     desc = "Find Buffers"         },
    { "<leader>fh", ":Telescope help_tags<cr>",   desc = "Help Tags"            },
    { "<leader>fn", ":Telescope notify<cr>",      desc = "Notification History" }
  }
end

function M.config()
  require('telescope').setup()
end

return M.init()

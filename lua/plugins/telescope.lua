local M = {
  'nvim-telescope/telescope.nvim',
  dependencies = { {'nvim-lua/plenary.nvim'} },
  cmd = { 'Telescope' },
}

function M.keys()
  local telescope = require('telescope')
  local builtin = require('telescope.builtin')

  return {
    {
      '<leader>ff',
      function()
        builtin.find_files()
      end,
      desc = 'Find Files'
    },
    {
      '<leader>fg',
      function()
        builtin.live_grep()
      end,
      desc = 'Live Grep'
    },
    {
      '<leader>fb',
      function()
        builtin.buffers()
      end,
      desc = 'Find Buffers'
    },
    {
      '<leader>fh',
      function()
        builtin.help_tags()
      end,
      desc = 'Help Tags'
    },
    {
      '<leader>fs',
      function()
        builtin.lsp_document_symbols()
      end,
      desc = 'Help Tags'
    },
    {
      '<leader>fn',
      function()
        telescope.load_extension('notify')
        telescope.extensions.notify.notify()
      end,
      desc = 'Notification History'
    }
  }
end

function M.opts()
  return {
    defaults = {
      layout_strategy = 'horizontal',
      layout_config = {
        prompt_position = 'bottom',
      },
    }
  }
end

function M.config(_, opts)
  local telescope = require('telescope')
  telescope.setup(opts)
end

return M

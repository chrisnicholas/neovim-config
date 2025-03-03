local M = {
  'nvim-telescope/telescope.nvim',
  lazy = true,
  dependencies = { {'nvim-lua/plenary.nvim'} },
  cmd = { 'Telescope' },
}

M.keys = {
  { '<leader>ff', '<CMD>Telescope find_files<CR>', desc = 'Find Files' },
  { '<leader>fg', '<CMD>Telescope live_grep<CR>', desc = 'Live Grep' },
  { '<leader>fb', '<CMD>Telescope buffers<CR>', desc = 'Find Buffers' },
  { '<leader>fh', '<CMD>Telescope help_tags<CR>', desc = 'Help Tags' },
  { '<leader>fs', '<CMD>Telescope lsp_document_symbols<CR>', desc = 'Help Tags' },
  {
    '<leader>fn',
    function()
      local telescope = require('telescope')
      telescope.load_extension('notify')
      telescope.extensions.notify.notify()
    end,
    desc = 'Notification History'
  }
}

M.opts = {
  defaults = {
    layout_strategy = 'horizontal',
    layout_config = {
      prompt_position = 'bottom',
    },
  }
}

return M

local M = {
  'nvim-telescope/telescope.nvim',
  cmd = { 'Telescope' },
}

M.keys = {
  { '<leader>ff', '<CMD>Telescope find_files<CR>', desc = 'Find Files' },
  { '<leader>fg', '<CMD>Telescope live_grep<CR>', desc = 'Live Grep' },
  { '<leader>fb', '<CMD>Telescope buffers<CR>', desc = 'Find Buffers' },
  { '<leader>fh', '<CMD>Telescope help_tags<CR>', desc = 'Help Tags' },
  { '<leader>fs', '<CMD>Telescope lsp_document_symbols<CR>', desc = 'Help Tags' },
  { '<leader>fn', '<CMD>Telescope notify<CR>', desc = 'Notification History' }
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

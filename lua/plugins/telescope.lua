local M = {
  'nvim-telescope/telescope.nvim',
  cmd = { 'Telescope' },
}

M.keys = {
  { '<leader>ff', '<CMD>Telescope find_files<CR>',           desc = 'Find Files' },
  { '<leader>fg', '<CMD>Telescope live_grep<CR>',            desc = 'Live Grep' },
  { '<leader>fb', '<CMD>Telescope buffers<CR>',              desc = 'Find Buffers' },
  { '<leader>fh', '<CMD>Telescope help_tags<CR>',            desc = 'Help Tags' },
  { '<leader>fs', '<CMD>Telescope lsp_document_symbols<CR>', desc = 'Help Tags' },
  { '<leader>fn', '<CMD>Telescope notify<CR>',               desc = 'Notification History' },
  { '<leader>fd', '<CMD>Telescope diagnostics<CR>',          desc = 'LSP Diagnostics' },
  { '<leader>gd', '<CMD>Telescope lsp_definitions<CR>',      desc = 'LSP Definitions' },
  { '<leader>gr', '<CMD>Telescope lsp_references<CR>',       desc = 'LSP References' },
  { '<leader>gi', '<CMD>Telescope lsp_implementations<CR>',  desc = 'LSP References' },
  { '<leader>gc', '<CMD>Telescope git_commits<CR>',          desc = 'Git Commits' },
  { '<leader>gb', '<CMD>Telescope git_branches<CR>',         desc = 'Git Branches' },
}

M.opts = {
  defaults = {
    layout_strategy = 'flex',
    sorting_strategy = 'ascending',
    layout_config = {
      prompt_position = 'top',
      flip_columns = 250,
      flip_lines = 40,
    },
  }
}

return M

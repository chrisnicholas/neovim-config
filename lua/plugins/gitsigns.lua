local M = {
  'lewis6991/gitsigns.nvim',
  event = 'BufReadPre',
}

function M.config()
  require('gitsigns').setup{
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local map = require('utils.keymap').map

      map('n', ']c', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, {expr=true})

      map('n', '[c', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, {expr=true})

      map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
      map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
      map('n', '<leader>tb', gs.toggle_current_line_blame)
      map('n', '<leader>bl', gs.blame_line)
    end
  }
end

return M

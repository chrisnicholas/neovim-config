local M = {
  'lewis6991/gitsigns.nvim',
  event = 'BufReadPre',
}

function M.config()
  local priorities = require('config.signs').priorities.gitsigns

  require('gitsigns').setup {
    signs = {
      add          = { text = '│', priority = priorities.add },
      change       = { text = '│', priority = priorities.change },
      delete       = { text = '_', priority = priorities.delete },
      topdelete    = { text = '‾', priority = priorities.topdelete },
      changedelete = { text = '~', priority = priorities.changedelete },
      untracked    = { text = '┆', priority = priorities.untracked },
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      vim.keymap.set('n', ']c', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, { expr = true, buffer = bufnr })

      vim.keymap.set('n', '[c', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, { expr = true, buffer = bufnr })

      vim.keymap.set({ 'n', 'v' }, '<leader>hs', gs.stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
      vim.keymap.set({ 'n', 'v' }, '<leader>hr', gs.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
      vim.keymap.set('n', '<leader>tb', gs.toggle_current_line_blame, { buffer = bufnr })
      vim.keymap.set('n', '<leader>hd', gs.diffthis, { buffer = bufnr, desc = "Diff against index" })
    end
  }
end

return M

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
      local get_visual_selection = require("utils").get_visual_selection

      next_hunk = function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end

      previous_hunk = function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end

      stage_hunk = function()
        gs.stage_hunk(get_visual_selection())
      end

      reset_hunk = function()
        gs.reset_hunk(get_visual_selection())
      end

      vim.keymap.set('n', ']c', next_hunk, { expr = true, buffer = bufnr, desc = "Next Hunk" })
      vim.keymap.set('n', '[c', previous_hunk, { expr = true, buffer = bufnr, desc = "Previous Hunk" })
      vim.keymap.set({ 'n', 'v' }, '<leader>hs', stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
      vim.keymap.set({ 'n', 'v' }, '<leader>hr', reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
      vim.keymap.set('n', '<leader>tb', gs.toggle_current_line_blame, { buffer = bufnr, desc = "Toggle Line Blame" })
      vim.keymap.set('n', '<leader>hd', gs.diffthis, { buffer = bufnr, desc = "Diff against index" })
    end
  }
end

return M

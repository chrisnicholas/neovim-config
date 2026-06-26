local M = {
  'lewis6991/gitsigns.nvim',
  event = 'BufReadPre',
}

--- Build the hunk-navigation/stage/reset handlers used by the buffer keymaps.
--- All editor interactions are injected via `deps` so the branching logic is
--- unit-testable:
---   deps.is_diff()              -> whether the window is in diff mode
---   deps.schedule(fn)           -> defer fn (vim.schedule)
---   deps.gs                     -> the gitsigns module
---   deps.get_visual_selection() -> selected line range (or nil)
--- The navigation handlers are `expr` mappings: in diff mode they fall back to
--- the native ]c / [c motions, otherwise they defer the gitsigns jump and
--- return <Ignore>.
function M.make_hunk_handlers(deps)
  local is_diff = deps.is_diff
  local schedule = deps.schedule
  local gs = deps.gs
  local get_visual_selection = deps.get_visual_selection

  return {
    next_hunk = function()
      if is_diff() then return ']c' end
      schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end,
    previous_hunk = function()
      if is_diff() then return '[c' end
      schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end,
    stage_hunk = function()
      gs.stage_hunk(get_visual_selection())
    end,
    reset_hunk = function()
      gs.reset_hunk(get_visual_selection())
    end,
  }
end

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

      local handlers = M.make_hunk_handlers({
        is_diff = function() return vim.wo.diff end,
        schedule = vim.schedule,
        gs = gs,
        get_visual_selection = require("utils").get_visual_selection,
      })

      vim.keymap.set('n', ']c', handlers.next_hunk, { expr = true, buffer = bufnr, desc = "Next Hunk" })
      vim.keymap.set('n', '[c', handlers.previous_hunk, { expr = true, buffer = bufnr, desc = "Previous Hunk" })
      vim.keymap.set({ 'n', 'v' }, '<leader>hs', handlers.stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
      vim.keymap.set({ 'n', 'v' }, '<leader>hr', handlers.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
      vim.keymap.set('n', '<leader>tb', gs.toggle_current_line_blame, { buffer = bufnr, desc = "Toggle Line Blame" })
      vim.keymap.set('n', '<leader>hd', gs.diffthis, { buffer = bufnr, desc = "Diff against index" })
    end
  }
end

return M

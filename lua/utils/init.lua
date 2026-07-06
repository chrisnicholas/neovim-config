local M = {}

-- Returns the selected line range `{ start, end }` when in visual mode
-- (char/line/blockwise), or nil otherwise. The editor lookups (current mode and
-- the two line numbers) are injectable via `opts` so the logic can be
-- unit-tested without a real visual selection; they default to the live
-- `vim.fn` values.
function M.get_visual_selection(opts)
  opts = opts or {}
  local mode = opts.mode or vim.fn.mode()
  local visual_start = opts.visual_start or vim.fn.line('v')
  local visual_end = opts.visual_end or vim.fn.line('.')

  -- '\22' is the raw Ctrl-V byte vim.fn.mode() returns for blockwise visual.
  if mode == 'V' or mode == 'v' or mode == '\22' then
    return { visual_start, visual_end }
  end

  return nil
end

return M

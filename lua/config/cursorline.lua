-- Highlight the current line in the active window only, skipping floating
-- windows and UI buffers (Telescope prompt, dashboard).
local M = {}

M.blocked_filetypes = {
  TelescopePrompt = true,
  snacks_dashboard = true,
}

-- Pure decision: whether the window described by ctx should show cursorline.
function M.should_highlight(ctx)
  if ctx.is_floating then
    return false
  end
  return not M.blocked_filetypes[ctx.filetype or '']
end

-- Registers the autocmds. opts.group is injectable for tests. BufWinEnter is
-- required in addition to WinEnter: it covers a buffer replacing another in
-- the same window (dashboard -> file, :e, Telescope pick), where no window
-- event fires.
function M.setup(opts)
  opts = opts or {}

  vim.api.nvim_create_autocmd({ 'VimEnter', 'WinEnter', 'BufWinEnter' }, {
    group = opts.group,
    callback = function(event)
      vim.opt_local.cursorline = M.should_highlight({
        filetype = vim.bo[event.buf].filetype,
        is_floating = vim.api.nvim_win_get_config(0).relative ~= '',
      })
    end,
  })

  vim.api.nvim_create_autocmd('WinLeave', {
    group = opts.group,
    callback = function()
      vim.opt_local.cursorline = false
    end,
  })
end

return M

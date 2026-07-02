-- Minimal init for headless test runs. Puts plenary (the busted runner) and this
-- config repo on the runtimepath, without loading the full config.

-- Optional coverage: when COVERAGE is set, start LuaCov before anything under
-- lua/ is required so its debug hook can record line hits. PlenaryBustedDirectory
-- runs one child Neovim per spec file; each child loads this init, so each one
-- must flush its stats on exit. runner.save_stats() merges into the shared
-- luacov.stats.out, accumulating coverage across every child process.
if vim.env.COVERAGE then
  local ok, runner = pcall(require, 'luacov.runner')
  if ok then
    runner.init()  -- loads .luacov from the repo root
    vim.api.nvim_create_autocmd('VimLeavePre', {
      callback = function() runner.save_stats() end,
    })
  else
    io.stderr:write('COVERAGE set but luacov could not be loaded: ' .. tostring(runner) .. '\n')
  end
end

local function data_path(sub)
  return vim.fn.stdpath('data') .. '/lazy/' .. sub
end

vim.opt.rtp:prepend(vim.fn.getcwd())
vim.opt.rtp:prepend(data_path('plenary.nvim'))

vim.cmd('runtime plugin/plenary.vim')

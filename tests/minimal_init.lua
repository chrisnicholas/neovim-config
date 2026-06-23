-- Minimal init for headless test runs. Puts plenary (the busted runner) and this
-- config repo on the runtimepath, without loading the full config.
local function data_path(sub)
  return vim.fn.stdpath('data') .. '/lazy/' .. sub
end

vim.opt.rtp:prepend(vim.fn.getcwd())
vim.opt.rtp:prepend(data_path('plenary.nvim'))

vim.cmd('runtime plugin/plenary.vim')

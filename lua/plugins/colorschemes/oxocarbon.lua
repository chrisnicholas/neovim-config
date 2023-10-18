local M = {
  'nyoom-engineering/oxocarbon.nvim',
  lazy = true,
  priority = 1000,
}

function M.config()
  vim.opt.background = 'dark'
  vim.cmd('colorscheme oxocarbon')
end

return M

local M = {
  'nyoom-engineering/oxocarbon',
  name = 'oxocarbon',
  lazy = true,
  priority = 1000,
}

M.opts = {
}

function M.config(_, opts)
  local oxocarbon = require('oxocarbon')
  oxocarbon.setup(opts)

  vim.opt.background = 'dark'
  vim.cmd('colorscheme oxocarbon')
end

return M

local M = {
  'rcarriga/nvim-notify',
  lazy = false,
}

function M.config()
  local nvim_notify = require('notify')
  vim.notify = nvim_notify
end

return M

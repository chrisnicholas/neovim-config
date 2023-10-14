local M = {}

function M.init()
  return {
    'rcarriga/nvim-notify',
    lazy = false,
    config = M.config
  }
end

function M.config()
  local nvim_notify = require('notify')
  vim.notify = nvim_notify
end

function M.init_keymaps()
end

return M.init()

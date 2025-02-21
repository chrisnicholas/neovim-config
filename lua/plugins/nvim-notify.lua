local M = {
  'rcarriga/nvim-notify',
  lazy = false,
}

function M.config()
  local nvim_notify = require('notify')

  nvim_notify.setup({
    stages = 'fade_in_slide_out',
    timeout = 5000,
    background_colour = '#282c34',
    text_colour = '#abb2bf',
    icons = {
      ERROR = '',
      WARN = '',
      INFO = '',
      DEBUG = '',
      TRACE = '✎',
    }
  })
  vim.notify = nvim_notify
end

return M

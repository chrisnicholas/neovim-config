local M = {
  'rcarriga/nvim-notify',
  lazy = true,
}

M.opts = {
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
}

return M

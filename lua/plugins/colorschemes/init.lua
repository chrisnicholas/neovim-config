local theme = require('plugins.colorschemes.theme')

local M = {}

function M.config()
  return {
    require('plugins.colorschemes.catppuccin'),
    require('plugins.colorschemes.github-nvim-theme'),
    require('plugins.colorschemes.oxocarbon'),
    require('plugins.colorschemes.tokyonight'),
    {
      'f-person/auto-dark-mode.nvim',
      lazy = false,
      opts = M.opts()
    }
  }
end

function M.opts()
  return {
    update_interval = 500,
    set_dark_mode = M.set_dark_mode,
    set_light_mode = M.set_light_mode
  }
end

function M.set_light_mode()
  theme.set_mode('light')
end

function M.set_dark_mode()
  theme.set_mode('dark')
end

return M.config()

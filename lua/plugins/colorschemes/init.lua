local LIGHT_COLORSCHEME = 'github_light_default'
local DARK_COLORSCHEME = 'github_dark_dimmed'

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
  M.set_colorscheme(LIGHT_COLORSCHEME, 'light', {})
end

function M.set_dark_mode()
  M.set_colorscheme(DARK_COLORSCHEME, 'dark', {})
end

function M.set_colorscheme(colorscheme, variant, opts)
  vim.api.nvim_set_option_value('background', variant, opts)
  vim.cmd.colorscheme(colorscheme)
end

return M.config()

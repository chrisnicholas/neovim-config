local M = {}

function M.config()
  return {
    require('plugins.colorschemes.catppuccin'),
    require('plugins.colorschemes.github-nvim-theme'),
    require('plugins.colorschemes.oxocarbon'),
    require('plugins.colorschemes.tokyonight')
  }
end

return M.config()

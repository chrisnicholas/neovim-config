local M = {
  'projekt0n/github-nvim-theme',
  lazy = false,
  priority = 1000,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}

function M.config()
  local github_theme = require("github-theme")
  github_theme.setup({
    options = {
      transparent = true,
    }
  })
end

return M

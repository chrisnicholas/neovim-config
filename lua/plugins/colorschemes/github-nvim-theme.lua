local M = {
  'projekt0n/github-nvim-theme',
  lazy = false,
  priority = 1000,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}

function M.config(_, opts)
  local github_theme = require("github-theme")
  github_theme.setup(opts)
  vim.cmd.colorscheme('github_dark_default')
end

return M

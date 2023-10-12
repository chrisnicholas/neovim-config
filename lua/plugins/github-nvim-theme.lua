local M = {}

function M.init()
  return {
    'projekt0n/github-nvim-theme',
    lazy = false,
    priority = 1000,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = M.opts,
    config = M.config
  }
end

function M.opts()
  return {}
end

function M.config(_, opts)
  local github_theme = require("github-theme")
  github_theme.setup(opts)
  vim.cmd.colorscheme('github_dark_dimmed')
end

return M.init()

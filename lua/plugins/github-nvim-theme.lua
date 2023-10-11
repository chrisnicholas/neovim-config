local M = {}

function M.init()
  return {
    'projekt0n/github-nvim-theme',
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = M.config
  }
end

function M.config()
  require("github-theme").setup({})
  vim.cmd.colorscheme('github_dark_dimmed')
end

return M.init()

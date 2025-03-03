local M = {
  'projekt0n/github-nvim-theme',
  name = 'github-theme',
  lazy = false,
  priority = 1000,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}

M.opts = {
  options = {
    transparent = true,
  }
}

return M

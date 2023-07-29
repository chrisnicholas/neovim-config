local M = {}

function M.init()
  local packer = require('packer')
  local use = packer.use

  packer.init()
  packer.reset()

  -- Plug-in Manager
  use('wbthomason/packer.nvim')

  -- Classic Vim Plug-ins
  use('tpope/vim-fugitive')
  use('tpope/vim-commentary')
  use('tpope/vim-rails')

  -- Lua Plug-ins
  use(require('plugins.github-nvim-theme')) 
  use(require('plugins.telescope'))
  use(require('plugins.nvim-lspconfig'))
  use(require('plugins.nvim-treesitter'))
  use(require('plugins.gitsigns'))
  use(require('plugins.nvim-tree'))
  use(require('plugins.lualine'))
end

M.init()

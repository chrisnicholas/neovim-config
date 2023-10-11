local M = {}

function M.init()
  M.bootstrap_lazy_nvim()

  local plugins = {
    -- Classic Vim Plugins
    'tpope/vim-fugitive',
    'tpope/vim-commentary',
    'tpope/vim-rails',

    -- Lua Plugins
    require('plugins.telescope'),
    require('plugins.github-nvim-theme'),
    require('plugins.nvim-lspconfig'),
    require('plugins.gitsigns'),
    require('plugins.lualine'),
    require('plugins.nvim-treesitter'),
    require('plugins.nvim-tree')
  }

  require("lazy").setup(plugins)
end

function M.bootstrap_lazy_nvim()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
end

M.init()

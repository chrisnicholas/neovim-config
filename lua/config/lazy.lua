local M = {}

function M.init()
  M.bootstrap()

  require('lazy').setup('plugins', {
    install = {
      missing = true,
      colorscheme = { 'github-theme', 'tokyonight', 'catppuccin' }
    },
    defaults = {
      lazy = true
    },
    ui = {
      border = 'rounded',
    },
    checker = {
      enabled = true
    },
    change_detection = {
      enabled = true,
      notify = false
    },
    performance = {
      cache = {
        enabled = true,
      },
      rtp = {
        disabled_plugins = {
          'gzip',
          'matchit',
          'matchparen',
          'netrwPlugin',
          'tarPlugin',
          'tohtml',
          'tutor',
          'zipPlugin',
        },
      },
    },
    rocks = {
      enabled = false,
      hererocks = false,
    },
    debug = false,
  })
end

function M.bootstrap()
  local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
end

M.init()

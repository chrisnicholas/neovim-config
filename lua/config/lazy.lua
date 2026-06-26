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

-- Clone lazy.nvim if missing and prepend it to the runtimepath. All side
-- effects are injectable (mirroring config.debug's ensure_installed) so the
-- logic can be unit-tested without touching git or the real rtp. Returns the
-- install path.
function M.bootstrap(opts)
  opts = opts or {}
  local lazypath = opts.path or (vim.fn.stdpath('data') .. '/lazy/lazy.nvim')
  local exists = opts.exists or function(p)
    return vim.uv.fs_stat(p) ~= nil
  end
  local clone = opts.clone or function(p)
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      p,
    })
  end
  local prepend = opts.prepend or function(p)
    vim.opt.rtp:prepend(p)
  end

  if not exists(lazypath) then
    clone(lazypath)
  end
  prepend(lazypath)
  return lazypath
end

return M

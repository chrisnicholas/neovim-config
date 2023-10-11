local M = {}

function M.init()
  M.bootstrap_lazy_nvim()

  require("lazy").setup("plugins", {
    install = { colorscheme = { "github-nvim-theme" } },
    defaults = { lazy = true },
    ui = {
      border = "rounded",
    },
    checker = { enabled = true },
    debug = false,
  })
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

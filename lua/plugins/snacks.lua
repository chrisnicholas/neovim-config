-- snacks.nvim
-- Reference:
-- https://github.com/folke/snacks.nvim/tree/main/docs

---@type LazySpec
local M = {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
}

M.keys = {
  { "<leader>tt", function() Snacks.terminal.toggle() end, desc = "Toggle Terminal" },
}

---@type snacks.Config
M.opts = {
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
  -- bigfile = { enabled = true },
  dashboard = { enabled = true },
  -- explorer = { enabled = true },
  indent = { enabled = true },
  -- input = { enabled = true },
  -- picker = { enabled = true },
  -- notifier = { enabled = true },
  -- quickfile = { enabled = true },
  scope = { enabled = true },
  -- scroll = { enabled = true },
  terminal = {
    enabled = true,
  },
  -- statuscolumn = { enabled = true },
  words = { enabled = true },
}

return M

-- Treesitter text objects. Works against the parsers in site/parser/ and the
-- queries vendored under nvim/queries/ (and the plugin's own textobjects.scm);
-- it does not depend on the nvim-treesitter core plugin.
---@type LazyPluginSpec
local M = {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  lazy = false,
}

function M.config()
  require("nvim-treesitter-textobjects").setup({
    select = { lookahead = true },
    move = { set_jumps = true },
  })

  local ts_select = require("nvim-treesitter-textobjects.select")
  vim.keymap.set({ "x", "o" }, "aa", function() ts_select.select_textobject("@parameter.outer") end, { desc = "Select outer parameter" })
  vim.keymap.set({ "x", "o" }, "ia", function() ts_select.select_textobject("@parameter.inner") end, { desc = "Select inner parameter" })
  vim.keymap.set({ "x", "o" }, "af", function() ts_select.select_textobject("@function.outer") end, { desc = "Select outer function" })
  vim.keymap.set({ "x", "o" }, "if", function() ts_select.select_textobject("@function.inner") end, { desc = "Select inner function" })
  vim.keymap.set({ "x", "o" }, "ac", function() ts_select.select_textobject("@class.outer") end, { desc = "Select outer class" })
  vim.keymap.set({ "x", "o" }, "ic", function() ts_select.select_textobject("@class.inner") end, { desc = "Select inner class" })

  local ts_move = require("nvim-treesitter-textobjects.move")
  vim.keymap.set({ "n", "x", "o" }, "]m", function() ts_move.goto_next_start("@function.outer") end, { desc = "Next function start" })
  vim.keymap.set({ "n", "x", "o" }, "]]", function() ts_move.goto_next_start("@class.outer") end, { desc = "Next class start" })
  vim.keymap.set({ "n", "x", "o" }, "]M", function() ts_move.goto_next_end("@function.outer") end, { desc = "Next function end" })
  vim.keymap.set({ "n", "x", "o" }, "][", function() ts_move.goto_next_end("@class.outer") end, { desc = "Next class end" })
  vim.keymap.set({ "n", "x", "o" }, "[m", function() ts_move.goto_previous_start("@function.outer") end, { desc = "Prev function start" })
  vim.keymap.set({ "n", "x", "o" }, "[[", function() ts_move.goto_previous_start("@class.outer") end, { desc = "Prev class start" })
  vim.keymap.set({ "n", "x", "o" }, "[M", function() ts_move.goto_previous_end("@function.outer") end, { desc = "Prev function end" })
  vim.keymap.set({ "n", "x", "o" }, "[]", function() ts_move.goto_previous_end("@class.outer") end, { desc = "Prev class end" })

  local ts_swap = require("nvim-treesitter-textobjects.swap")
  vim.keymap.set("n", "<leader>a", function() ts_swap.swap_next("@parameter.inner") end, { desc = "Swap next parameter" })
  vim.keymap.set("n", "<leader>A", function() ts_swap.swap_previous("@parameter.inner") end, { desc = "Swap prev parameter" })
end

return M

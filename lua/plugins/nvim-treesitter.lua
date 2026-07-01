local parsers = {
  "bash",
  "c",
  "css",
  "dockerfile",
  "go",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "ruby",
  "rust",
  "swift",
  "terraform",
  "typescript",
  "vim",
  "vimdoc",
}

---@type LazyPluginSpec
local M = {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
    "nvim-treesitter/nvim-treesitter-context",
  },
}

function M.config()
  local ts = require("nvim-treesitter")

  -- Install any parsers we don't have yet (fresh machine)...
  ts.install(parsers)
  -- ...then self-heal a half-migrated install: parsers whose `.so` is present
  -- but whose highlight queries aren't linked into the install dir. Neither
  -- install() (skips installed parsers) nor update()/:TSUpdate (short-circuits
  -- on the grammar revision) repairs this, so force a reinstall of just the
  -- affected langs. See lua/utils/treesitter.lua for the why.
  local site = vim.fs.joinpath(vim.fn.stdpath("data"), "site")
  local unlinked = require("utils.treesitter").unlinked_query_langs(site, parsers)
  if #unlinked > 0 then
    ts.install(unlinked, { force = true })
  end

  -- Enable treesitter highlighting and indentation for filetypes with a parser
  vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
      if pcall(vim.treesitter.start, args.buf) then
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end,
  })

  -- Textobjects
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

  -- Treesitter context (sticky function/class headers)
  require("treesitter-context").setup({ enable = true })

  -- Code Folding
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  vim.opt.foldlevel = 99
  vim.opt.foldlevelstart = -1
  vim.opt.foldenable = true
end

return M

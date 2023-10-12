local M = {}

function M.init()
  return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    lazy = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-refactor",
    },
    opts = M.opts,
    config = M.config
  }
end

function M.opts()
  return {
    highlight = {
      enable = true,
      disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,
      additional_vim_regex_highlighting = false,
    },
    autopairs = { enable = true },
    autotag = { enable = true },
    indent = { enable = true },
    ensure_installed = {
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
      "query",
      "ruby",
      "rust",
      "swift",
      "typescript",
      "vim",
      "vimdoc",
    },
    sync_install = true,
    ignore_install = {},
    refactor = {
      highlight_definitions = {
        enable = true,
        clear_on_cursor_move = true,
      },
      highlight_current_scope = { enable = false },
    },
  }
end

function M.config(_, opts)
  local nvim_treesitter = require('nvim-treesitter.configs')
  nvim_treesitter.setup(opts)
end

return M.init()

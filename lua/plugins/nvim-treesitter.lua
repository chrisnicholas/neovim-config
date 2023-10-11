local M = {}

function M.init()
  return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = 'BufReadPost',
    dependencies = {
      "nvim-treesitter/nvim-treesitter-refactor",
    },
    config = M.config
  }
end

M.opts = {
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
      -- Set to false if you have an `updatetime` of ~100.
      clear_on_cursor_move = true,
    },
    highlight_current_scope = { enable = false },
  },
}

function M.config()
  require('nvim-treesitter.configs').setup(M.opts)
end

return M.init()

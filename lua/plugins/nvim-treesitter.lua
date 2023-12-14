local M = {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  }

M.opts = {
  highlight = {
    enable = true,
    disable = function(_, buf)
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
    "terraform",
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

function M.config(_, opts)
  local nvim_treesitter = require('nvim-treesitter.configs')
  nvim_treesitter.setup(opts)

  -- Code Folding
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
  vim.opt.foldlevel = 99
  vim.opt.foldlevelstart = -1
  vim.opt.foldenable = true
end

return M

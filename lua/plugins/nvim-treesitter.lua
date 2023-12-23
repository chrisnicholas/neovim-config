local M = {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "nvim-treesitter/nvim-treesitter-refactor",
    "nvim-treesitter/nvim-treesitter-context",
  },
}

M.opts = {
  highlight = { enable = true },
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
    "python",
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
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
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

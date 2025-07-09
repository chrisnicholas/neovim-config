local M = {
  settings = {
    Lua = {
      format = {
        enable = true, -- Enable formatting
        -- defaultConfig = {
        --   indent_style = 'space',
        --   indent_size = '2',
        --   quote_style = 'single',
        --   line_length = '80',
        --   align_multiline_comment = false,
        --   continuation_indent = '2',
        -- },
      },
      runtime = {
        -- Tell the language server which version of Lua you're using (most
        -- likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Tell the language server how to find Lua modules same way as Neovim
        -- (see `:h lua-module-load`)
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          '${3rd}/luv/library',
          '${3rd}/busted/library',
        }
        -- Or pull in all of 'runtimepath'.
        -- NOTE: this is a lot slower and will cause issues when working on
        -- your own configuration.
        -- See https://github.com/neovim/nvim-lspconfig/issues/3189
        -- library = {
        --   vim.api.nvim_get_runtime_file('', true),
        -- }
      }
    }
  }
}

return M

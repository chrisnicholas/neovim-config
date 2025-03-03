local function on_attach(_, bufnr)
  local bufopts = { noremap = true, buffer = bufnr }

  vim.keymap.set('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', bufopts)
  vim.keymap.set('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', bufopts)
  vim.keymap.set('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', bufopts)
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', bufopts)
  vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', bufopts)
end

local MasonSpec = {
  "williamboman/mason.nvim",
  dependencies = { "williamboman/mason-lspconfig.nvim" }
}

function MasonSpec.config()
  require('mason').setup({})
  require('mason-lspconfig').setup({})
end

local LspConfigSpec = {
  'neovim/nvim-lspconfig',
  dependencies = { MasonSpec },
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  cmd = 'LspInfo',
}

function LspConfigSpec.config()
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  require('plugins.lsp.bashls').init(on_attach, capabilities)
  require('plugins.lsp.gopls').init(on_attach, capabilities)
  require('plugins.lsp.lua_ls').init(on_attach, capabilities)
  require('plugins.lsp.pyright').init(on_attach, capabilities)
  -- Optionally use ruby lsp if ruby version is new enough.
  -- require('plugins.lsp.ruby_lsp').init(on_attach, capabilities)
  require('plugins.lsp.solargraph').init(on_attach, capabilities)
  require('plugins.lsp.cucumber-language-server').init(on_attach, capabilities)
  require('plugins.lsp.typescript_language_server').init(on_attach, capabilities)
  require('plugins.lsp.terraform_ls').init(on_attach, capabilities)
end

return LspConfigSpec

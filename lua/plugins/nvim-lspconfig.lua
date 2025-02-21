local M = {
  'neovim/nvim-lspconfig',
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  cmd = 'LspInfo',
}

M.dependencies = {
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim"
}

function M.config()
  require('mason').setup({})
  require('mason-lspconfig').setup({})

  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  require('plugins.lsp.bashls').init(M.on_attach)
  require('plugins.lsp.gopls').init(M.on_attach, capabilities)
  require('plugins.lsp.lua_ls').init(M.on_attach, capabilities)
  require('plugins.lsp.pyright').init(M.on_attach)
  -- Optionally use ruby lsp if ruby version is new enough.
  -- require('plugins.lsp.ruby_lsp').init(M.on_attach, capabilities)
  require('plugins.lsp.solargraph').init(M.on_attach, capabilities)
  require('plugins.lsp.cucumber-language-server').init(M.on_attach, capabilities)
  require('plugins.lsp.typescript_language_server').init(M.on_attach)
  require('plugins.lsp.terraform_ls').init(M.on_attach)
end

function M.on_attach(_, bufnr)
  local bufopts = { noremap = true, buffer = bufnr }

  vim.keymap.set('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', bufopts)
  vim.keymap.set('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', bufopts)
  vim.keymap.set('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', bufopts)
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', bufopts)
  vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', bufopts)
end

return M

local function on_attach(_, bufnr)
  local bufopts = { noremap = true, buffer = bufnr }

  vim.keymap.set('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', bufopts)
  vim.keymap.set('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', bufopts)
  vim.keymap.set('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', bufopts)
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', bufopts)
  vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', bufopts)
end


local MasonLspConfigSpec = {
  "williamboman/mason-lspconfig.nvim",
}

MasonLspConfigSpec.opts = {
  ensure_installed = {},
  automatic_installation = true,
}

local MasonSpec = {
  "williamboman/mason.nvim",
  lazy = false,
  main = 'mason',
  config = true,
}

local LspConfigSpec = {
  'neovim/nvim-lspconfig',
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  dependencies = { MasonLspConfigSpec },
  cmd = 'LspInfo',
}

function LspConfigSpec.config()
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  require('plugins.lsp.bashls').init(on_attach, capabilities)
  require('plugins.lsp.gopls').init(on_attach, capabilities)
  require('plugins.lsp.lua_ls').init(on_attach, capabilities)
  require('plugins.lsp.pyright').init(on_attach, capabilities)
  require('plugins.lsp.ruby_lsp').init(on_attach, capabilities)
  require('plugins.lsp.solargraph').init(on_attach, capabilities)
  require('plugins.lsp.cucumber-language-server').init(on_attach, capabilities)
  require('plugins.lsp.typescript_language_server').init(on_attach, capabilities)
  require('plugins.lsp.terraform_ls').init(on_attach, capabilities)
end

return {
  MasonSpec,
  LspConfigSpec,
}

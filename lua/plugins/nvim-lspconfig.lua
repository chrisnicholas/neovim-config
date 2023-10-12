local M = {}

function M.init()
  return {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    config = M.config
  }
end

function M.config()
  require('plugins.lsp.gopls').init(M.on_attach)
  require('plugins.lsp.lua_ls').init(M.on_attach)
  require('plugins.lsp.solargraph').init(M.on_attach)
end

function M.on_attach(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local bufopts = { noremap = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', bufopts)
  vim.keymap.set('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', bufopts)
  vim.keymap.set('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', bufopts)
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', bufopts)
  vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', bufopts)
end

return M.init()


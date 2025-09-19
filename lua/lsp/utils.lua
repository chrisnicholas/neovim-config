--- Utility functions for LSP server configurations.
---@class LSPUtils
local LSPUtils = {}

--- Returns the offset encoding used by the LSP client.
--- Defaults to "utf-16" if not specified.
---@param client vim.lsp.Client
function LSPUtils.get_client_encoding(client)
  return client.offset_encoding
      or (client.server_capabilities and client.server_capabilities.offsetEncoding)
      or "utf-16"
end

function LSPUtils.get_client_range_params(client)
  return vim.lsp.util.make_range_params(0, LSPUtils.get_client_encoding(client))
end

--- LSP keymaps that (most likely) apply to any server.
--- Expects autocmd event-args as `event`.
--- See :h event-args
---@private
function LSPUtils.set_lsp_keymaps(event)
  local opts = { buffer = event.buf }

  -- Keymaps
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', 'g?', vim.diagnostic.open_float, opts)
end

--- TODO: Maybe don't format with *every* attached client that supports it.
---
--- Formats the current buffer using the LSP client.
--- Expects autocmd event-args as `event`.
--- See :h event-args
---@private
function LSPUtils.format_buffer_with_lsp(event)
  local active_clients = vim.lsp.get_clients({ bufnr = event.buf })

  for _, client in ipairs(active_clients) do
    if client ~= nil and client:supports_method("textDocument/formatting", event.buf) then
      vim.lsp.buf.format({ bufnr = event.buf })
    end
  end
end

function LSPUtils.create_lsp_autocommands()
  local group_config = require("config.augroup").lsp
  local lsp_augroup = vim.api.nvim_create_augroup(group_config.name, group_config.opts)

  -- Create keymaps on attach
  vim.api.nvim_create_autocmd("LspAttach", {
    group = lsp_augroup,
    callback = LSPUtils.set_lsp_keymaps,
  })

  -- Format file on save
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = lsp_augroup,
    callback = LSPUtils.format_buffer_with_lsp,
  })
end

return LSPUtils

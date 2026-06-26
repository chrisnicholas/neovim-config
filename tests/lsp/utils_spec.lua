local LSPUtils = require('lsp.utils')

describe('lsp.utils', function()
  describe('get_client_encoding', function()
    it('uses the client offset_encoding when present', function()
      assert.equals('utf-8', LSPUtils.get_client_encoding({ offset_encoding = 'utf-8' }))
    end)

    it('falls back to server_capabilities.offsetEncoding', function()
      local client = { server_capabilities = { offsetEncoding = 'utf-32' } }
      assert.equals('utf-32', LSPUtils.get_client_encoding(client))
    end)

    it('defaults to utf-16 when nothing is specified', function()
      assert.equals('utf-16', LSPUtils.get_client_encoding({}))
      assert.equals('utf-16', LSPUtils.get_client_encoding({ server_capabilities = {} }))
    end)
  end)

  describe('format_buffer_with_lsp', function()
    local saved_get_clients, saved_format

    before_each(function()
      saved_get_clients = vim.lsp.get_clients
      saved_format = vim.lsp.buf.format
    end)

    after_each(function()
      vim.lsp.get_clients = saved_get_clients
      vim.lsp.buf.format = saved_format
    end)

    it('does not format when no client supports formatting', function()
      local formatted = false
      vim.lsp.get_clients = function() return {} end
      vim.lsp.buf.format = function() formatted = true end

      LSPUtils.format_buffer_with_lsp({ buf = 7 })

      assert.is_false(formatted)
    end)

    it('formats with the first available client', function()
      local format_args
      vim.lsp.get_clients = function() return { { id = 42 }, { id = 99 } } end
      vim.lsp.buf.format = function(args) format_args = args end

      LSPUtils.format_buffer_with_lsp({ buf = 7 })

      assert.same({ bufnr = 7, id = 42 }, format_args)
    end)
  end)
end)

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

  describe('goimports', function()
    local saved_get_clients, saved_request_sync, saved_apply_edit

    before_each(function()
      saved_get_clients = vim.lsp.get_clients
      saved_request_sync = vim.lsp.buf_request_sync
      saved_apply_edit = vim.lsp.util.apply_workspace_edit
    end)

    after_each(function()
      vim.lsp.get_clients = saved_get_clients
      vim.lsp.buf_request_sync = saved_request_sync
      vim.lsp.util.apply_workspace_edit = saved_apply_edit
    end)

    it('is a no-op when no gopls client is attached', function()
      local requested = false
      vim.lsp.get_clients = function() return {} end
      vim.lsp.buf_request_sync = function() requested = true end

      LSPUtils.goimports({ buf = 7 })

      assert.is_false(requested)
    end)

    it('applies workspace edits from the organizeImports code action', function()
      local buf = vim.api.nvim_create_buf(false, true)
      -- A distinct name so uri_from_bufnr(buf) differs from the current
      -- window's (unnamed) buffer URI — otherwise both are "file://" and the
      -- URI assertion below cannot catch a wrong-buffer regression.
      vim.api.nvim_buf_set_name(buf, 'goimports-test-target.go')
      local applied = {}
      vim.lsp.get_clients = function() return { { offset_encoding = 'utf-8' } } end
      vim.lsp.buf_request_sync = function(bufnr, method, params)
        assert.equals(buf, bufnr)
        assert.equals('textDocument/codeAction', method)
        assert.equals(vim.uri_from_bufnr(buf), params.textDocument.uri)
        assert.same({ only = { 'source.organizeImports' } }, params.context)
        return { { result = { { edit = 'EDIT' }, { command = 'no-edit' } } } }
      end
      vim.lsp.util.apply_workspace_edit = function(edit, encoding)
        table.insert(applied, { edit, encoding })
      end

      LSPUtils.goimports({ buf = buf })

      assert.same({ { 'EDIT', 'utf-8' } }, applied)
      vim.api.nvim_buf_delete(buf, { force = true })
    end)
  end)
end)

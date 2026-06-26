local lsp = require('plugins.lsp')

describe('plugins.lsp', function()
  describe('load_custom_config', function()
    it('returns the custom config table for a server that has one', function()
      local cfg = lsp.load_custom_config('gopls')
      assert.is_true(cfg.settings.gopls.usePlaceholders)
    end)

    it('returns an empty table when no custom config exists', function()
      assert.same({}, lsp.load_custom_config('definitely_not_a_real_server'))
    end)
  end)

  describe('merge_server_config', function()
    it('lets custom config override default keys', function()
      local merged = lsp.merge_server_config(
        { cmd = { 'a' }, single_file_support = true },
        { cmd = { 'b' } }
      )
      assert.same({ 'b' }, merged.cmd)
      assert.is_true(merged.single_file_support)
    end)

    it('deep-merges nested tables', function()
      local merged = lsp.merge_server_config(
        { settings = { x = 1, y = 2 } },
        { settings = { y = 3 } }
      )
      assert.same({ x = 1, y = 3 }, merged.settings)
    end)
  end)
end)

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

  describe('ensure_mason_tools', function()
    -- Minimal stand-in for a mason-registry Package: colon-called methods, so
    -- they take `self`.
    local function fake_package(installed)
      return {
        install_calls = 0,
        is_installed = function() return installed end,
        install = function(self) self.install_calls = self.install_calls + 1 end,
      }
    end

    it('installs a tool that is not present yet', function()
      local pkg = fake_package(false)
      local registry = { get_package = function() return pkg end }

      local started = lsp.ensure_mason_tools({ 'golangci-lint' }, registry)

      assert.same({ 'golangci-lint' }, started)
      assert.equals(1, pkg.install_calls)
    end)

    it('leaves an already-installed tool alone', function()
      local pkg = fake_package(true)
      local registry = { get_package = function() return pkg end }

      local started = lsp.ensure_mason_tools({ 'golangci-lint' }, registry)

      assert.same({}, started)
      assert.equals(0, pkg.install_calls)
    end)

    it('skips a tool the registry does not know about', function()
      local registry = {
        get_package = function() error('Package not found: nope') end,
      }

      assert.same({}, lsp.ensure_mason_tools({ 'nope' }, registry))
    end)

    it('returns an empty list for an empty tool list', function()
      local registry = { get_package = function() error('should not be called') end }

      assert.same({}, lsp.ensure_mason_tools({}, registry))
    end)
  end)
end)

local debug_mod = require('config.debug')

describe('config.debug', function()
  describe('enabled', function()
    it('is true for a set value', function()
      assert.is_true(debug_mod.enabled({ [debug_mod.env_var] = '1' }))
      assert.is_true(debug_mod.enabled({ [debug_mod.env_var] = 'yes' }))
    end)

    it('is false when unset, empty, or "0"', function()
      assert.is_false(debug_mod.enabled({}))
      assert.is_false(debug_mod.enabled({ [debug_mod.env_var] = '' }))
      assert.is_false(debug_mod.enabled({ [debug_mod.env_var] = '0' }))
    end)
  end)

  describe('log_enabled', function()
    it('tracks the NVIM_DEBUG_LOG env var', function()
      assert.is_true(debug_mod.log_enabled({ [debug_mod.log_env_var] = '1' }))
      assert.is_false(debug_mod.log_enabled({}))
      assert.is_false(debug_mod.log_enabled({ [debug_mod.log_env_var] = '0' }))
    end)
  end)

  describe('ensure_installed', function()
    it('clones once and prepends when the path is missing', function()
      local cloned, prepended = {}, {}
      local path, did_clone = debug_mod.ensure_installed({
        path = '/tmp/osv',
        exists = function() return false end,
        clone = function(p) table.insert(cloned, p) end,
        prepend = function(p) table.insert(prepended, p) end,
      })

      assert.equals('/tmp/osv', path)
      assert.is_true(did_clone)
      assert.same({ '/tmp/osv' }, cloned)
      assert.same({ '/tmp/osv' }, prepended)
    end)

    it('does not clone when the path already exists but still prepends', function()
      local cloned, prepended = {}, {}
      local path, did_clone = debug_mod.ensure_installed({
        path = '/tmp/osv',
        exists = function() return true end,
        clone = function(p) table.insert(cloned, p) end,
        prepend = function(p) table.insert(prepended, p) end,
      })

      assert.equals('/tmp/osv', path)
      assert.is_false(did_clone)
      assert.same({}, cloned)
      assert.same({ '/tmp/osv' }, prepended)
    end)
  end)

  describe('setup', function()
    it('is a no-op when debugging is disabled', function()
      -- env = {} -> disabled, so osv is never required and nothing blocks.
      assert.is_false(debug_mod.setup({ env = {} }))
    end)
  end)
end)

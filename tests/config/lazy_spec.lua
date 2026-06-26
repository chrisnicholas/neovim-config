local lazy = require('config.lazy')

describe('config.lazy', function()
  describe('bootstrap', function()
    it('clones lazy.nvim and prepends it when missing', function()
      local cloned, prepended = {}, {}
      local path = lazy.bootstrap({
        path = '/tmp/lazy',
        exists = function() return false end,
        clone = function(p) table.insert(cloned, p) end,
        prepend = function(p) table.insert(prepended, p) end,
      })
      assert.equals('/tmp/lazy', path)
      assert.same({ '/tmp/lazy' }, cloned)
      assert.same({ '/tmp/lazy' }, prepended)
    end)

    it('does not clone when already installed but still prepends', function()
      local cloned, prepended = {}, {}
      lazy.bootstrap({
        path = '/tmp/lazy',
        exists = function() return true end,
        clone = function(p) table.insert(cloned, p) end,
        prepend = function(p) table.insert(prepended, p) end,
      })
      assert.same({}, cloned)
      assert.same({ '/tmp/lazy' }, prepended)
    end)
  end)
end)

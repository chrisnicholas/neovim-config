local env = require('utils.env')

describe('utils.env', function()
  describe('has_browser', function()
    it('is true on macOS even with no display variables', function()
      assert.is_true(env.has_browser({ is_mac = true, env = {} }))
    end)

    it('is true on linux under X11', function()
      assert.is_true(env.has_browser({ is_mac = false, env = { DISPLAY = ':0' } }))
    end)

    it('is true on linux under wayland', function()
      assert.is_true(env.has_browser({ is_mac = false, env = { WAYLAND_DISPLAY = 'wayland-0' } }))
    end)

    it('is false on a headless linux box', function()
      assert.is_false(env.has_browser({ is_mac = false, env = {} }))
    end)

    it('treats an empty display string as unset', function()
      assert.is_false(env.has_browser({
        is_mac = false,
        env = { DISPLAY = '', WAYLAND_DISPLAY = '' },
      }))
    end)
  end)
end)

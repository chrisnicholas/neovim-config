local theme = require('plugins.colorschemes.theme')

describe('plugins.colorschemes.theme', function()
  describe('set_mode', function()
    it('applies the light colorscheme with a light background', function()
      local applied
      theme.set_mode('light', function(cs, variant) applied = { cs, variant } end)
      assert.same({ 'github_light_default', 'light' }, applied)
    end)

    it('applies the dark colorscheme with a dark background', function()
      local applied
      theme.set_mode('dark', function(cs, variant) applied = { cs, variant } end)
      assert.same({ 'github_dark_dimmed', 'dark' }, applied)
    end)
  end)
end)

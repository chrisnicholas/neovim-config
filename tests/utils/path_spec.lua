local path = require('utils.path')

describe('utils.path', function()
  describe('append_line_range', function()
    it('appends a single line number when both lines match', function()
      assert.equals('foo.lua:10', path.append_line_range('foo.lua', 10, 10))
    end)

    it('appends a range when the lines differ', function()
      assert.equals('foo.lua:10-15', path.append_line_range('foo.lua', 10, 15))
    end)

    it('normalises a bottom-up selection (a > b)', function()
      assert.equals('foo.lua:10-15', path.append_line_range('foo.lua', 15, 10))
    end)
  end)

  describe('format_path', function()
    it('returns the bare path when not in visual mode', function()
      assert.equals('foo.lua', path.format_path('foo.lua', false, 10, 15))
    end)

    it('ignores the line numbers entirely when not visual', function()
      -- nil lines must not be read on the non-visual path.
      assert.equals('foo.lua', path.format_path('foo.lua', false))
    end)

    it('appends a single line for a one-line visual selection', function()
      assert.equals('foo.lua:7', path.format_path('foo.lua', true, 7, 7))
    end)

    it('appends a range for a multi-line visual selection', function()
      assert.equals('foo.lua:7-9', path.format_path('foo.lua', true, 7, 9))
    end)
  end)
end)

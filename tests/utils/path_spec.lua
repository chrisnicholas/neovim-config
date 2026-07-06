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
end)

local utils = require('utils')

describe('utils.get_visual_selection', function()
  it('returns the line range in charwise visual mode', function()
    assert.same({ 3, 8 }, utils.get_visual_selection({
      mode = 'v',
      visual_start = 3,
      visual_end = 8,
    }))
  end)

  it('returns the line range in linewise visual mode', function()
    assert.same({ 3, 8 }, utils.get_visual_selection({
      mode = 'V',
      visual_start = 3,
      visual_end = 8,
    }))
  end)

  it('returns nil outside visual mode', function()
    assert.is_nil(utils.get_visual_selection({
      mode = 'n',
      visual_start = 3,
      visual_end = 8,
    }))
  end)

  it('preserves selection direction (start may exceed end)', function()
    assert.same({ 8, 3 }, utils.get_visual_selection({
      mode = 'v',
      visual_start = 8,
      visual_end = 3,
    }))
  end)
end)

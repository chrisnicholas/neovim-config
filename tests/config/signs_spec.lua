local signs = require('config.signs')

describe('config.signs', function()
  local p = signs.priorities

  it('orders sign priority dap > gitsigns > diagnostics', function()
    -- Higher priority wins when multiple signs land on the same line.
    assert.is_true(p.dap.breakpoint > p.gitsigns.add)
    assert.is_true(p.gitsigns.add > p.diagnostics)
  end)

  it('uses a single shared priority within each group', function()
    for _, v in pairs(p.dap) do
      assert.equals(p.dap.breakpoint, v)
    end
    for _, v in pairs(p.gitsigns) do
      assert.equals(p.gitsigns.add, v)
    end
  end)
end)

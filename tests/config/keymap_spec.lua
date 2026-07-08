-- Smoke test only: the mappings are declarative data, so per-mapping
-- assertions would just transcribe the file. This catches the module failing
-- to load or the maps silently disappearing.
require('config.keymap')

describe('config.keymap', function()
  it('registers the window-navigation keymaps', function()
    for _, lhs in ipairs({ '<A-h>', '<A-j>', '<A-k>', '<A-l>' }) do
      assert.is_true(vim.fn.maparg(lhs, 'n') ~= '', lhs .. ' is not mapped')
    end
  end)

  it('registers the scrolling and half-paging keymaps', function()
    for _, lhs in ipairs({ '<Up>', '<Down>', '<Left>', '<Right>', '<S-Up>', '<S-Down>', '<S-Left>', '<S-Right>' }) do
      assert.is_true(vim.fn.maparg(lhs, 'n') ~= '', lhs .. ' is not mapped')
    end
  end)
end)

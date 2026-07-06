local pathcopy = require('config.pathcopy')

describe('config.pathcopy', function()
  describe('copy', function()
    -- Fake deps: expansion resolves to `expanded`, selection is fixed, and the
    -- register write is recorded instead of touching the clipboard.
    local function fake_deps(selection, expanded)
      local calls = {}
      local deps = {
        expand = function(expr)
          calls.expand = expr
          return expanded
        end,
        setreg = function(reg, value)
          calls.setreg = { reg = reg, value = value }
        end,
        get_visual_selection = function()
          return selection
        end,
      }
      return deps, calls
    end

    it('copies the bare path outside visual mode', function()
      local deps, calls = fake_deps(nil, 'lua/config/pathcopy.lua')

      local result = pathcopy.copy('%:.', deps)

      assert.equals('%:.', calls.expand)
      assert.equals('lua/config/pathcopy.lua', result)
      assert.same({ reg = '+', value = 'lua/config/pathcopy.lua' }, calls.setreg)
    end)

    it('appends the line range in visual mode', function()
      local deps, calls = fake_deps({ 3, 8 }, 'foo.lua')

      pathcopy.copy('%:p', deps)

      assert.same({ reg = '+', value = 'foo.lua:3-8' }, calls.setreg)
    end)

    it('normalises bottom-up selections', function()
      local deps, calls = fake_deps({ 8, 3 }, 'foo.lua')

      pathcopy.copy('%:p', deps)

      assert.equals('foo.lua:3-8', calls.setreg.value)
    end)

    it('collapses single-line selections to :N', function()
      local deps, calls = fake_deps({ 4, 4 }, 'foo.lua')

      pathcopy.copy('%:p', deps)

      assert.equals('foo.lua:4', calls.setreg.value)
    end)
  end)

  describe('setup', function()
    it('registers the three keymaps in normal and visual mode', function()
      pathcopy.setup()

      for _, lhs in ipairs({ '<leader>cfp', '<leader>crp', '<leader>cfn' }) do
        for _, mode in ipairs({ 'n', 'v' }) do
          local map = vim.fn.maparg(lhs, mode, false, true)
          assert.is_truthy(map.callback, ('%s not mapped in mode %s'):format(lhs, mode))
        end
      end
    end)

    it('wires the filename keymap through real expansion', function()
      local recorded
      pathcopy.setup({
        setreg = function(reg, value)
          recorded = { reg = reg, value = value }
        end,
      })
      vim.api.nvim_buf_set_name(0, 'dir/myfile.lua')

      vim.fn.maparg('<leader>cfn', 'n', false, true).callback()

      assert.same({ reg = '+', value = 'myfile.lua' }, recorded)
    end)
  end)
end)

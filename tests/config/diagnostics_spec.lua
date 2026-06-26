local Diagnostics = require('config.diagnostics')

describe('config.diagnostics', function()
  describe('highest_severity_per_line', function()
    -- Output order is not guaranteed; sort by line to assert deterministically.
    local function by_lnum(list)
      table.sort(list, function(a, b) return a.lnum < b.lnum end)
      return list
    end

    it('keeps only the highest-severity diagnostic per line', function()
      -- Lower severity number = higher severity (ERROR=1, WARN=2).
      local result = Diagnostics.highest_severity_per_line({
        { lnum = 0, severity = 2, message = 'warn' },
        { lnum = 0, severity = 1, message = 'error' },
      })
      assert.equals(1, #result)
      assert.equals(1, result[1].severity)
      assert.equals('error', result[1].message)
    end)

    it('preserves one diagnostic for each distinct line', function()
      local result = by_lnum(Diagnostics.highest_severity_per_line({
        { lnum = 0, severity = 1 },
        { lnum = 5, severity = 2 },
        { lnum = 5, severity = 1 },
      }))
      assert.equals(2, #result)
      assert.equals(0, result[1].lnum)
      assert.equals(5, result[2].lnum)
      assert.equals(1, result[2].severity)
    end)

    it('returns an empty list for empty input', function()
      assert.same({}, Diagnostics.highest_severity_per_line({}))
    end)
  end)
end)

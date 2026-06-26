local gitsigns = require('plugins.gitsigns')

describe('plugins.gitsigns', function()
  -- Build handlers with fully stubbed deps. `schedule` runs the callback
  -- immediately so the underlying gs.* call can be asserted.
  local function make(opts)
    opts = opts or {}
    local calls = { scheduled = {} }
    local gs = {
      next_hunk = function() calls.next_hunk = true end,
      prev_hunk = function() calls.prev_hunk = true end,
      stage_hunk = function(range) calls.staged = range end,
      reset_hunk = function(range) calls.reset = range end,
    }
    local handlers = gitsigns.make_hunk_handlers({
      is_diff = function() return opts.diff == true end,
      schedule = function(fn) table.insert(calls.scheduled, fn); fn() end,
      gs = gs,
      get_visual_selection = function() return opts.selection end,
    })
    return handlers, calls
  end

  describe('next_hunk', function()
    it('returns the native ]c mapping in diff mode without scheduling', function()
      local h, calls = make({ diff = true })
      assert.equals(']c', h.next_hunk())
      assert.is_nil(calls.next_hunk)
      assert.equals(0, #calls.scheduled)
    end)

    it('schedules gs.next_hunk and returns <Ignore> outside diff mode', function()
      local h, calls = make({ diff = false })
      assert.equals('<Ignore>', h.next_hunk())
      assert.is_true(calls.next_hunk)
    end)
  end)

  describe('previous_hunk', function()
    it('returns the native [c mapping in diff mode', function()
      local h = make({ diff = true })
      assert.equals('[c', h.previous_hunk())
    end)

    it('schedules gs.prev_hunk and returns <Ignore> outside diff mode', function()
      local h, calls = make({ diff = false })
      assert.equals('<Ignore>', h.previous_hunk())
      assert.is_true(calls.prev_hunk)
    end)
  end)

  describe('stage_hunk / reset_hunk', function()
    it('passes the visual selection to gs.stage_hunk', function()
      local h, calls = make({ selection = { 3, 8 } })
      h.stage_hunk()
      assert.same({ 3, 8 }, calls.staged)
    end)

    it('passes the visual selection to gs.reset_hunk', function()
      local h, calls = make({ selection = { 3, 8 } })
      h.reset_hunk()
      assert.same({ 3, 8 }, calls.reset)
    end)
  end)
end)

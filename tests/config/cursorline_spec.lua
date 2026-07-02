local cursorline = require('config.cursorline')

describe('config.cursorline', function()
  describe('should_highlight', function()
    it('is false in floating windows', function()
      assert.is_false(cursorline.should_highlight({ is_floating = true, filetype = 'lua' }))
    end)

    it('is false for blocked filetypes', function()
      assert.is_false(cursorline.should_highlight({ filetype = 'TelescopePrompt' }))
      assert.is_false(cursorline.should_highlight({ filetype = 'snacks_dashboard' }))
    end)

    it('is true for normal and empty filetypes', function()
      assert.is_true(cursorline.should_highlight({ filetype = 'lua' }))
      assert.is_true(cursorline.should_highlight({ filetype = '' }))
      assert.is_true(cursorline.should_highlight({}))
    end)
  end)

  describe('setup', function()
    local group

    before_each(function()
      group = vim.api.nvim_create_augroup('test.cursorline', { clear = true })
      cursorline.setup({ group = group })
      vim.wo.cursorline = false
    end)

    after_each(function()
      vim.api.nvim_del_augroup_by_id(group)
    end)

    local function show_buffer_with_ft(ft)
      local buf = vim.api.nvim_create_buf(false, true)
      vim.bo[buf].filetype = ft
      vim.api.nvim_win_set_buf(0, buf)
      return buf
    end

    it('enables cursorline when entering a window with a normal buffer', function()
      show_buffer_with_ft('lua')
      vim.api.nvim_exec_autocmds('WinEnter', { group = group })
      assert.is_true(vim.wo.cursorline)
    end)

    it('disables cursorline for blocked filetypes', function()
      vim.wo.cursorline = true
      show_buffer_with_ft('snacks_dashboard')
      vim.api.nvim_exec_autocmds('WinEnter', { group = group })
      assert.is_false(vim.wo.cursorline)
    end)

    -- Regression: a normal buffer replacing a blocked one in the *same window*
    -- (dashboard -> open file, :e, Telescope pick) must re-enable cursorline.
    -- Only WinEnter fires no event here; BufWinEnter does.
    it('re-enables cursorline when a normal buffer replaces a blocked one in the same window', function()
      show_buffer_with_ft('snacks_dashboard')
      vim.api.nvim_exec_autocmds('WinEnter', { group = group })
      assert.is_false(vim.wo.cursorline)

      show_buffer_with_ft('lua')
      vim.api.nvim_exec_autocmds('BufWinEnter', { group = group })
      assert.is_true(vim.wo.cursorline)
    end)

    it('disables cursorline on WinLeave', function()
      show_buffer_with_ft('lua')
      vim.api.nvim_exec_autocmds('WinEnter', { group = group })
      assert.is_true(vim.wo.cursorline)

      vim.api.nvim_exec_autocmds('WinLeave', { group = group })
      assert.is_false(vim.wo.cursorline)
    end)
  end)
end)

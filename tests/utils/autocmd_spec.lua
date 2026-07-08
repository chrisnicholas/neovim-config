local autocmd = require('utils.autocmd')

describe('utils.autocmd', function()
  local function scratch_with_ft(ft)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_current_buf(buf)
    vim.bo.filetype = ft
    return buf
  end

  describe('autocmd', function()
    it('runs the command when the event fires for the pattern', function()
      autocmd.autocmd('User', 'UtilsAutocmdSpec', 'let g:utils_autocmd_spec_hit = 1')
      vim.cmd('doautocmd User UtilsAutocmdSpec')
      assert.equals(1, vim.g.utils_autocmd_spec_hit)
    end)
  end)

  describe('filetype', function()
    it('applies the command when the filetype is set', function()
      autocmd.filetype('utilsautocmdspec', 'setlocal tabstop=3')
      scratch_with_ft('utilsautocmdspec')
      assert.equals(3, vim.bo.tabstop)
    end)

    it('applies the command to every filetype in a list', function()
      autocmd.filetype({ 'utilsspec_aaa', 'utilsspec_bbb' }, 'setlocal shiftwidth=7')
      scratch_with_ft('utilsspec_aaa')
      assert.equals(7, vim.bo.shiftwidth)
      scratch_with_ft('utilsspec_bbb')
      assert.equals(7, vim.bo.shiftwidth)
    end)

    it('does not apply the command to other filetypes', function()
      autocmd.filetype('utilsspec_ccc', 'setlocal tabstop=5')
      scratch_with_ft('utilsspec_other')
      assert.not_equals(5, vim.bo.tabstop)
    end)
  end)
end)

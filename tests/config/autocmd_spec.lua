require('config.autocmd')

describe('config.autocmd', function()
  local function scratch_with_ft(ft)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_current_buf(buf)
    vim.bo.filetype = ft
    return buf
  end

  it('go uses tabs at a width of 4', function()
    scratch_with_ft('go')
    assert.is_false(vim.bo.expandtab)
    assert.equals(0, vim.bo.shiftwidth)
    assert.equals(4, vim.bo.tabstop)
  end)

  it('lua uses two-space indentation', function()
    scratch_with_ft('lua')
    assert.is_true(vim.bo.expandtab)
    assert.equals(2, vim.bo.shiftwidth)
    assert.equals(2, vim.bo.tabstop)
  end)

  it('applies to every filetype in a list (javascript and json)', function()
    scratch_with_ft('javascript')
    assert.is_true(vim.bo.expandtab)
    assert.equals(2, vim.bo.shiftwidth)
    scratch_with_ft('json')
    assert.is_true(vim.bo.expandtab)
    assert.equals(2, vim.bo.shiftwidth)
  end)

  it('markdown wraps at word boundaries with a 78-column guide', function()
    scratch_with_ft('markdown')
    assert.is_true(vim.wo.wrap)
    assert.is_true(vim.wo.linebreak)
    assert.equals('78', vim.wo.colorcolumn)
  end)

  it('treats .pryrc files as ruby with two-space indentation', function()
    vim.cmd.edit(vim.fn.tempname() .. '.pryrc')
    assert.equals('ruby', vim.bo.filetype)
    assert.equals('ruby', vim.bo.syntax)
    assert.is_true(vim.bo.expandtab)
    assert.equals(2, vim.bo.shiftwidth)
    vim.cmd('bwipeout!')
  end)
end)

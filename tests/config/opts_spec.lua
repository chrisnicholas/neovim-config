require('config.opts')
local title = require('config.title')

describe('config.opts', function()
  it('updates the titlestring on BufEnter', function()
    vim.opt.titlestring = ''
    vim.cmd('doautocmd BufEnter')
    assert.not_equals('', vim.o.titlestring)
    assert.equals(title.titlestring(), vim.o.titlestring)
  end)

  it('updates the titlestring on DirChanged', function()
    local before = vim.o.titlestring
    local dir = vim.fn.tempname() .. '-opts-spec'
    vim.fn.mkdir(dir, 'p')
    vim.cmd.cd(dir)
    assert.not_equals(before, vim.o.titlestring)
    assert.equals(title.titlestring(), vim.o.titlestring)
    vim.fn.delete(dir, 'rf')
  end)
end)

local augroup = require('config.augroup')

-- Characterization test: config.augroup is pure data, so this guards the
-- group naming/options against accidental change rather than driving new code.
describe('config.augroup', function()
  it('namespaces group names with the com.cn. prefix', function()
    assert.equals('com.cn.lsp', augroup.lsp.name)
    assert.equals('com.cn.opts', augroup.nvim_opts.name)
  end)

  it('clears groups by default', function()
    assert.is_true(augroup.lsp.opts.clear)
    assert.is_true(augroup.nvim_opts.opts.clear)
  end)
end)

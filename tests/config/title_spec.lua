local title = require('config.title')

describe('config.title', function()
  describe('titlestring', function()
    local dir, prev_cwd

    -- Run from a known directory so the cwd component of the title is
    -- predictable, with a clean single-tab, empty-buffer slate.
    before_each(function()
      prev_cwd = vim.fn.getcwd()
      dir = vim.fn.tempname() .. '-title-spec'
      vim.fn.mkdir(dir, 'p')
      vim.cmd.cd(dir)
      vim.cmd.enew()
    end)

    after_each(function()
      vim.cmd('silent! tabonly!')
      vim.cmd('silent! %bwipeout!')
      vim.cmd.cd(prev_cwd)
      vim.fn.delete(dir, 'rf')
    end)

    local function dir_tail()
      return vim.fn.fnamemodify(dir, ':t')
    end

    it('shows only program and directory when no file is open', function()
      assert.equals(('[%s] %s'):format(vim.v.progname, dir_tail()), title.titlestring())
    end)

    it('appends the file and its status flags when a file is open', function()
      vim.cmd.edit('foo.txt')
      assert.equals(
        ('[%s] %s -- foo.txt %%h%%m%%r%%w'):format(vim.v.progname, dir_tail()),
        title.titlestring()
      )
    end)

    it('appends the tab position when more than one tab is open', function()
      vim.cmd.tabnew()
      assert.equals(
        ('[%s] %s (Tab 2 of 2)'):format(vim.v.progname, dir_tail()),
        title.titlestring()
      )
    end)
  end)
end)

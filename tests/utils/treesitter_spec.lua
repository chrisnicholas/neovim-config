local ts = require('utils.treesitter')

describe('utils.treesitter', function()
  describe('unlinked_query_langs', function()
    local dir

    -- Build a fake nvim-treesitter install dir under a fresh temp path. The
    -- real layout is install_dir/parser/<lang>.so and install_dir/queries/<lang>.
    before_each(function()
      dir = vim.fn.tempname()
      vim.fn.mkdir(vim.fs.joinpath(dir, 'parser'), 'p')
      vim.fn.mkdir(vim.fs.joinpath(dir, 'queries'), 'p')
    end)

    after_each(function()
      vim.fn.delete(dir, 'rf')
    end)

    local function add_parser(lang)
      vim.fn.writefile({}, vim.fs.joinpath(dir, 'parser', lang .. '.so'))
    end

    local function add_query_dir(lang)
      vim.fn.mkdir(vim.fs.joinpath(dir, 'queries', lang), 'p')
    end

    it('flags a lang whose parser is installed but queries are missing', function()
      add_parser('css') -- parser present, no queries/css -> half-migrated
      assert.same({ 'css' }, ts.unlinked_query_langs(dir, { 'css' }))
    end)

    it('does not flag a lang whose queries are linked', function()
      add_parser('go')
      add_query_dir('go') -- parser present AND queries present -> healthy
      assert.same({}, ts.unlinked_query_langs(dir, { 'go' }))
    end)

    it('does not flag a lang with no parser installed at all', function()
      -- python is requested but nothing is installed; update()/install() will
      -- handle a truly-missing parser, so it is not our concern.
      assert.same({}, ts.unlinked_query_langs(dir, { 'python' }))
    end)

    it('flags a dangling query symlink (points nowhere)', function()
      add_parser('html')
      vim.uv.fs_symlink(vim.fs.joinpath(dir, 'does-not-exist'), vim.fs.joinpath(dir, 'queries', 'html'))
      assert.same({ 'html' }, ts.unlinked_query_langs(dir, { 'html' }))
    end)

    it('returns only the broken langs from a mixed set, preserving order', function()
      add_parser('css') -- broken
      add_parser('go')
      add_query_dir('go') -- healthy
      add_parser('typescript') -- broken
      assert.same({ 'css', 'typescript' }, ts.unlinked_query_langs(dir, { 'css', 'go', 'typescript', 'python' }))
    end)
  end)
end)

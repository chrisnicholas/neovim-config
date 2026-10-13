-- Exercises scripts/bootstrap.sh's tree-sitter version gate by sourcing the
-- script in bash (which defines its functions without running main) and calling
-- ts_version_ok against a stub `tree-sitter` that reports a chosen version.

local script = vim.fs.joinpath(vim.fn.getcwd(), 'scripts', 'bootstrap.sh')
local bash = vim.fn.exepath('bash')

describe('scripts/bootstrap.sh', function()
  describe('ts_version_ok', function()
    local dir, bin

    before_each(function()
      dir = vim.fn.tempname()
      bin = vim.fs.joinpath(dir, 'bin')
      vim.fn.mkdir(bin, 'p')
    end)

    after_each(function()
      vim.fn.delete(dir, 'rf')
    end)

    -- Put a `tree-sitter` on the stub PATH that prints `tree-sitter <version>`.
    local function stub_tree_sitter(version)
      local exe = vim.fs.joinpath(bin, 'tree-sitter')
      vim.fn.writefile({ '#!/bin/sh', ('echo "tree-sitter %s"'):format(version) }, exe)
      vim.fn.setfperm(exe, 'rwxr-xr-x')
    end

    -- Source the script and report whether the gate passes. PATH is narrowed to
    -- the stub dir plus system dirs, and HOME is a throwaway, so even if sourcing
    -- ever ran the install steps it could not touch the real ~/.local/bin.
    local function version_ok()
      local res = vim.system({ bash, '-c', 'source "$1" && { ts_version_ok && echo ok || echo no; }', '_', script }, {
        env = { PATH = bin .. ':/usr/bin:/bin', HOME = dir },
        clear_env = true,
        text = true,
      }):wait()
      return vim.trim(res.stdout)
    end

    for _, v in ipairs({ '0.26.1', '0.26.12', '0.27.0', '1.0.0', '0.26.1-dev' }) do
      it(('accepts %s'):format(v), function()
        stub_tree_sitter(v)
        assert.equals('ok', version_ok())
      end)
    end

    -- 0.26.0 is the case a major.minor-only check would wrongly accept.
    for _, v in ipairs({ '0.25.9', '0.26.0', 'garbage', '' }) do
      it(('rejects %q'):format(v), function()
        stub_tree_sitter(v)
        assert.equals('no', version_ok())
      end)
    end

    it('rejects when tree-sitter is not on PATH', function()
      assert.equals('no', version_ok())
    end)
  end)
end)

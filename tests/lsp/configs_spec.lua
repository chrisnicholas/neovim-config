-- Conformance tests: every config under lua/lsp/configs/ must be a partial
-- vim.lsp.Config — only whitelisted fields, each with an allowed type.
--
-- SCHEMA is hand-maintained from Neovim 0.12's annotations
-- ($VIMRUNTIME/lua/vim/lsp.lua @class vim.lsp.Config and
-- $VIMRUNTIME/lua/vim/lsp/client.lua @class vim.lsp.ClientConfig).
-- If Neovim adds a field, add it here; a stale schema fails loudly,
-- it never passes silently.
local SCHEMA = {
  before_init = { 'function' },
  capabilities = { 'table' },
  cmd = { 'table', 'function' },
  cmd_cwd = { 'string' },
  cmd_env = { 'table' },
  commands = { 'table' },
  detached = { 'boolean' },
  exit_timeout = { 'number', 'boolean' },
  filetypes = { 'table' },
  flags = { 'table' },
  get_language_id = { 'function' },
  handlers = { 'table' },
  init_options = { 'table' },
  name = { 'string' },
  offset_encoding = { 'string' },
  on_attach = { 'function', 'table' },
  on_error = { 'function' },
  on_exit = { 'function', 'table' },
  on_init = { 'function', 'table' },
  reuse_client = { 'function' },
  root_dir = { 'string', 'function' },
  root_markers = { 'table' },
  settings = { 'table' },
  trace = { 'string' },
  workspace_folders = { 'table' },
  workspace_required = { 'boolean' },
}

-- Fields that, when present as tables, must be lists of non-empty strings.
local STRING_LIST_FIELDS = { 'cmd', 'filetypes' }

--- Server names discovered from lua/lsp/configs/*.lua (repo-root-relative;
--- scripts/test.sh always runs from the repo root).
local function config_names()
  local names = {}
  for _, path in ipairs(vim.fn.glob('lua/lsp/configs/*.lua', false, true)) do
    table.insert(names, vim.fn.fnamemodify(path, ':t:r'))
  end
  table.sort(names)
  return names
end

describe('lsp.configs', function()
  local names = config_names()

  it('discovers config files', function()
    assert.is_true(#names > 0, 'no configs found under lua/lsp/configs/')
  end)

  for _, name in ipairs(names) do
    describe(name, function()
      local ok, config = pcall(require, 'lsp.configs.' .. name)

      it('loads and returns a table', function()
        assert.is_true(ok, ('%s: failed to load: %s'):format(name, tostring(config)))
        assert.equals('table', type(config))
      end)

      it('only contains vim.lsp.Config fields with allowed types', function()
        if type(config) ~= 'table' then return end
        for key, value in pairs(config) do
          local allowed = SCHEMA[key]
          assert.is_not_nil(allowed,
            ('%s: `%s` is not a vim.lsp.Config field'):format(name, tostring(key)))
          assert.is_true(vim.tbl_contains(allowed, type(value)),
            ('%s.%s: expected %s, got %s'):format(
              name, tostring(key), table.concat(allowed, ' or '), type(value)))
        end
      end)

      it('uses non-empty string lists for list fields', function()
        if type(config) ~= 'table' then return end
        for _, field in ipairs(STRING_LIST_FIELDS) do
          local list = config[field]
          if type(list) == 'table' then
            assert.is_true(vim.islist(list),
              ('%s.%s: expected a list'):format(name, field))
            assert.is_true(#list > 0,
              ('%s.%s: expected a non-empty list'):format(name, field))
            for i, item in ipairs(list) do
              assert.is_true(type(item) == 'string' and item ~= '',
                ('%s.%s[%d]: expected non-empty string, got %s'):format(
                  name, field, i, vim.inspect(item)))
            end
          end
        end
      end)
    end)
  end
end)

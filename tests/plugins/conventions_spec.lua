-- Guards that every file under lua/plugins/ returns a lazy-compatible spec and
-- follows this config's personal conventions. The file set mirrors how lazy
-- actually imports `plugins` (top-level *.lua plus each subdirectory's
-- init.lua), so pure helpers like colorschemes/theme.lua are correctly not
-- treated as specs.

-- Discover the plugin-definition modules lazy would import, as require()able
-- module names (e.g. 'plugins.copilot', 'plugins.colorschemes').
local function discover()
  local paths = vim.fn.glob('lua/plugins/*.lua', false, true)
  vim.list_extend(paths, vim.fn.glob('lua/plugins/*/init.lua', false, true))
  local modules = {}
  for _, path in ipairs(paths) do
    local mod = path:gsub('^lua/', ''):gsub('%.lua$', ''):gsub('/', '.'):gsub('%.init$', '')
    table.insert(modules, mod)
  end
  table.sort(modules)
  return modules
end

-- A lazy spec module returns either a single spec (string source at [1]) or a
-- (possibly nested) list of specs. Flatten to the leaf specs.
local function collect_leaves(spec, acc)
  if type(spec) ~= 'table' then return acc end
  if type(spec[1]) == 'string' then
    table.insert(acc, spec)
  else
    for _, child in ipairs(spec) do
      collect_leaves(child, acc)
    end
  end
  return acc
end

local SOURCE_PATTERN = '^[%w._-]+/[%w._-]+$'

local function validate_leaf(spec, ctx)
  -- Source: non-empty "author/repo".
  local source = spec[1]
  assert.equals('string', type(source), ctx .. ': spec[1] must be a string source')
  assert.is_true(source ~= '', ctx .. ': spec[1] must be non-empty')
  assert.is_truthy(
    source:match(SOURCE_PATTERN),
    ('%s: source %q must match author/repo'):format(ctx, source)
  )

  -- Type-sanity for lazy compatibility.
  local function check(field, ...)
    if spec[field] == nil then return end
    local allowed = { ... }
    local actual = type(spec[field])
    assert.is_truthy(
      vim.tbl_contains(allowed, actual),
      ('%s: %s.%s should be %s, got %s'):format(ctx, source, field, table.concat(allowed, '/'), actual)
    )
  end
  check('enabled', 'boolean')
  check('lazy', 'boolean')
  check('event', 'string', 'table')
  check('cmd', 'string', 'table')
  check('ft', 'string', 'table')
  check('keys', 'table')
  check('dependencies', 'table')
  check('opts', 'table', 'function')
  check('config', 'function')
  check('init', 'function')

  -- Convention: every table-form keymap carries a non-empty desc.
  if type(spec.keys) == 'table' then
    for i, entry in ipairs(spec.keys) do
      if type(entry) == 'table' then
        local lhs = entry[1]
        assert.equals('string', type(entry.desc),
          ('%s: %s keys[%d] (%s) is missing a desc'):format(ctx, source, i, tostring(lhs)))
        assert.is_true(entry.desc ~= '',
          ('%s: %s keys[%d] (%s) has an empty desc'):format(ctx, source, i, tostring(lhs)))
      end
    end
  end
end

describe('plugin definition conventions', function()
  local modules = discover()

  for _, name in ipairs(modules) do
    it(name .. ' returns valid lazy spec(s)', function()
      local ok, spec = pcall(require, name)
      assert.is_true(ok, ('%s failed to load: %s'):format(name, tostring(spec)))
      assert.equals('table', type(spec), name .. ' must return a table')

      local leaves = collect_leaves(spec, {})
      assert.is_true(#leaves >= 1, name .. ' produced no plugin specs')
      for _, leaf in ipairs(leaves) do
        validate_leaf(leaf, name)
      end
    end)
  end

  it('defines each plugin source only once', function()
    local seen = {}
    for _, name in ipairs(modules) do
      for _, leaf in ipairs(collect_leaves(require(name), {})) do
        local source = leaf[1]
        assert.is_nil(seen[source],
          ('source %q defined in both %s and %s'):format(source, tostring(seen[source]), name))
        seen[source] = name
      end
    end
  end)
end)

-- Copy the current file's path to the system clipboard, appending the selected
-- line range in visual mode (e.g. `file.lua:10-15`). The editor interactions
-- (expand, register write, selection lookup) are injectable via `deps` so the
-- logic is unit-testable, mirroring plugins/gitsigns.lua.
local path = require('utils.path')

local M = {}

-- Expand `expansion` (e.g. '%:p') and write it to the `+` register, with a
-- `:N[-M]` suffix when a visual selection is active. Returns the copied string.
function M.copy(expansion, deps)
  deps = deps or {}
  local expand = deps.expand or vim.fn.expand
  local setreg = deps.setreg or vim.fn.setreg
  local get_visual_selection = deps.get_visual_selection or require('utils').get_visual_selection

  local file_path = expand(expansion)
  local range = get_visual_selection()
  if range then
    file_path = path.append_line_range(file_path, range[1], range[2])
  end

  setreg('+', file_path)
  return file_path
end

-- Register the path-copy keymaps. `deps` is forwarded to copy() (used by tests
-- to avoid the real clipboard).
function M.setup(deps)
  local maps = {
    ['<leader>cfp'] = '%:p', -- absolute path
    ['<leader>crp'] = '%:.', -- path relative to cwd
    ['<leader>cfn'] = '%:t', -- filename only
  }
  for lhs, expansion in pairs(maps) do
    vim.keymap.set({ 'n', 'v' }, lhs, function()
      M.copy(expansion, deps)
    end)
  end
end

return M

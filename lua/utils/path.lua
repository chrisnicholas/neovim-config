-- Pure helpers for formatting file paths. Side-effect-free so the formatting
-- logic (used by config/pathcopy.lua) can be unit-tested without touching the
-- editor state.
local M = {}

-- Append a line-range suffix to a path. A single line yields ":N"; a range
-- yields ":N-M". The two line numbers may be given in either order (a visual
-- selection can be made bottom-up), so they are normalised with min/max.
function M.append_line_range(base, line_a, line_b)
  local lo = math.min(line_a, line_b)
  local hi = math.max(line_a, line_b)
  if lo == hi then
    return base .. ":" .. lo
  end
  return base .. ":" .. lo .. "-" .. hi
end

return M

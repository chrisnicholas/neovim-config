-- Pure environment predicates. Kept side-effect-free so plugin specs can gate
-- on them at load time and still be unit-tested without a real editor session.
local M = {}

-- Can this machine actually open a web browser?
--
-- Plugins that shell out to one (markdown-preview) are dead weight on a
-- headless remote box: the preview server binds to a localhost nothing can
-- reach, and their node/yarn `build` step fails during Ansible provisioning.
-- macOS always can; on Linux we need a display server.
--
-- `opts.is_mac` and `opts.env` are injectable for testing and default to the
-- live editor values.
function M.has_browser(opts)
  opts = opts or {}

  local is_mac = opts.is_mac
  if is_mac == nil then
    is_mac = vim.fn.has('mac') == 1
  end
  if is_mac then
    return true
  end

  local environment = opts.env or vim.env
  local function is_set(name)
    local value = environment[name]
    return value ~= nil and value ~= ''
  end

  return is_set('DISPLAY') or is_set('WAYLAND_DISPLAY')
end

return M

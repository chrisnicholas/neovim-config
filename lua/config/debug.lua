-- Bootstrap for debugging the Neovim config *itself* during startup.
--
-- lazy.nvim only loads plugins after `require('config.lazy')` runs (the last
-- line of init.lua), so the DAP plugins are unavailable while the early config
-- modules execute. To break *before* `require('config.opts')`, the Lua DAP
-- server (one-small-step-for-vimkind / osv) is bootstrapped here, outside of
-- lazy, and started at the very top of init.lua.
--
-- `osv.launch({ blocking = true })` starts a DAP server and blocks startup until
-- a DAP client attaches and finishes configuration, then installs the Lua debug
-- hook and returns -- so the next lines of init.lua are traced and hit
-- breakpoints. Gated behind the NVIM_DEBUG environment variable so normal
-- startup is unaffected.
--
-- Stepping note: stepping *into* a `require()` call lands in Neovim's package
-- loader (`vim/_init_packages`), not your module, and stepping back *out* across
-- that C boundary hangs osv. So step *over* `require` lines; to enter a module
-- set a breakpoint inside it. Step in/out works normally for plain Lua calls.
local M = {}

M.env_var = 'NVIM_DEBUG'
M.log_env_var = 'NVIM_DEBUG_LOG'
M.repo = 'https://github.com/jbyuki/one-small-step-for-vimkind.git'
M.install_path = vim.fn.stdpath('data') .. '/debug/one-small-step-for-vimkind'
M.port = 8086

local function truthy(v)
  return v ~= nil and v ~= '' and v ~= '0'
end

-- Whether debugging is enabled (NVIM_DEBUG set) for the given env (defaults to vim.env).
function M.enabled(env)
  return truthy((env or vim.env)[M.env_var])
end

-- Whether osv logging is enabled (NVIM_DEBUG_LOG set). osv writes to
-- `stdpath('data')/osv.log` -- useful for diagnosing attach/stepping issues.
function M.log_enabled(env)
  return truthy((env or vim.env)[M.log_env_var])
end

-- Clone osv if missing and prepend it to the runtimepath. Mirrors the lazy.nvim
-- bootstrap pattern in lua/config/lazy.lua. All side effects are injectable so
-- the logic can be unit-tested without touching git or the real rtp.
-- Returns the install path and whether a clone happened.
function M.ensure_installed(opts)
  opts = opts or {}
  local path = opts.path or M.install_path
  local exists = opts.exists or function(p)
    return vim.uv.fs_stat(p) ~= nil
  end
  local clone = opts.clone or function(p)
    vim.fn.system({ 'git', 'clone', '--filter=blob:none', M.repo, p })
  end
  local prepend = opts.prepend or function(p)
    vim.opt.rtp:prepend(p)
  end

  local cloned = false
  if not exists(path) then
    clone(path)
    cloned = true
  end
  prepend(path)
  return path, cloned
end

-- osv prints "Server started on port N" while launching. During startup that
-- message triggers a blocking "Press ENTER or type command to continue" prompt
-- that looks like a launch error. Run `fn` with plain `print` swallowed so the
-- (blocking) launch stays quiet; restored afterwards even on error.
function M.quietly(fn)
  local saved = _G.print
  _G.print = function() end
  local ok, err = pcall(fn)
  _G.print = saved
  if not ok then
    error(err)
  end
end

-- Entry point called from init.lua. No-op unless NVIM_DEBUG is set. When it is,
-- bootstraps osv and launches the blocking DAP server, returning true (it
-- blocks until a debugger attaches). Returns false when debugging is disabled.
function M.setup(opts)
  opts = opts or {}
  if not M.enabled(opts.env) then
    return false
  end
  M.ensure_installed(opts)
  local log = M.log_enabled(opts.env)
  -- `launch` is injectable so the enabled path can be unit-tested without
  -- requiring osv or starting a blocking DAP server.
  local launch = opts.launch or function(o)
    require('osv').launch(o)
  end
  M.quietly(function()
    launch({ port = M.port, blocking = true, log = log })
  end)
  return true
end

return M

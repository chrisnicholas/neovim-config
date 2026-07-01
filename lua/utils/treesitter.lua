-- Pure helpers for detecting a half-migrated nvim-treesitter install, kept
-- side-effect-free so the detection logic can be unit-tested against a fake
-- install dir without touching the editor or the network.
--
-- Background: the nvim-treesitter `main` branch stores highlight queries as
-- symlinks under install_dir/queries/<lang>, created when a parser is installed.
-- Neither `install()` nor `update()`/`:TSUpdate` will recreate a missing query
-- link once the parser is present: `install()` skips any lang whose `.so`
-- exists, and `update()` short-circuits on the recorded grammar revision before
-- it ever checks the query link. So a parser that keeps its `.so` (and revision)
-- but loses its queries/<lang> link stays silently broken -- highlighting dies
-- for that language. This module finds those langs so the config can force a
-- reinstall of just them.
local M = {}

-- Given an nvim-treesitter `install_dir` (e.g. stdpath('data')/site) and the
-- list of `langs` the config wants, return the subset whose parser is installed
-- but whose highlight queries are not linked (missing or dangling symlink).
-- Langs with no installed parser are ignored -- a truly-missing parser is
-- install()'s job, not ours.
function M.unlinked_query_langs(install_dir, langs)
  local out = {}
  for _, lang in ipairs(langs) do
    local so = vim.fs.joinpath(install_dir, 'parser', lang .. '.so')
    local queries = vim.fs.joinpath(install_dir, 'queries', lang)
    if vim.uv.fs_stat(so) and not vim.uv.fs_realpath(queries) then
      out[#out + 1] = lang
    end
  end
  return out
end

return M

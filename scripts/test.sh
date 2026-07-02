#!/usr/bin/env bash
#
# Run the Lua test suite headlessly with plenary's busted runner.
#
# plenary.nvim (installed by lazy.nvim) provides the busted-compatible runner.
# tests/minimal_init.lua puts plenary and this repo on the runtimepath without
# loading the full config.
#
# Usage:
#   scripts/test.sh                       # run all specs under tests/
#   scripts/test.sh tests/config/debug_spec.lua  # run a single spec file
#
# Coverage:
#   COVERAGE=1 scripts/test.sh            # also print a LuaCov summary table
#
#   Requires luarocks + the `luacov` rock. `luarocks path` puts luacov on
#   LUA_PATH (which Neovim's LuaJIT honors) so the per-spec child processes can
#   load it, and on PATH so the reporter binary is found. Coverage only works
#   for the full-suite run: PlenaryBustedFile does not pass minimal_init to its
#   child, so a single-file run records nothing.

set -euo pipefail

cd "$(dirname "$0")/.."

command -v nvim >/dev/null || { echo "error: nvim not found" >&2; exit 1; }

COVERAGE="${COVERAGE:-}"
if [ -n "$COVERAGE" ]; then
  command -v luarocks >/dev/null || { echo "error: COVERAGE set but luarocks not found" >&2; exit 1; }
  eval "$(luarocks path)"
  export COVERAGE
  rm -f luacov.stats.out luacov.report.out
fi

if [ "$#" -gt 0 ]; then
  nvim --headless --noplugin -u tests/minimal_init.lua \
    -c "PlenaryBustedFile $1"
else
  nvim --headless --noplugin -u tests/minimal_init.lua \
    -c "PlenaryBustedDirectory tests/ { minimal_init = 'tests/minimal_init.lua' }"
fi

if [ -n "$COVERAGE" ] && [ -f luacov.stats.out ]; then
  luacov
  # Extract the Summary table, stripping the working-dir prefix for brevity.
  summary="$(awk '/^Summary$/{p=1} p' luacov.report.out | sed "s#${PWD}/##g")"
  echo
  echo "$summary"
  # On GitHub Actions, also surface the table on the job's summary page.
  if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then
    { echo '## Coverage'; echo '```'; echo "$summary"; echo '```'; } >> "$GITHUB_STEP_SUMMARY"
  fi
fi

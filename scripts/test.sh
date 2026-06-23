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

set -euo pipefail

cd "$(dirname "$0")/.."

command -v nvim >/dev/null || { echo "error: nvim not found" >&2; exit 1; }

if [ "$#" -gt 0 ]; then
  nvim --headless --noplugin -u tests/minimal_init.lua \
    -c "PlenaryBustedFile $1"
else
  nvim --headless --noplugin -u tests/minimal_init.lua \
    -c "PlenaryBustedDirectory tests/ { minimal_init = 'tests/minimal_init.lua' }"
fi

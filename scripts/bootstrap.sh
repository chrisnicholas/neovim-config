#!/usr/bin/env bash
#
# Bring a machine to the point where this Neovim config starts clean.
#
# Idempotent, needs no sudo, safe to re-run: every step no-ops when already
# satisfied. The `devbox` Ansible role calls this after cloning dotfiles; run
# it by hand on a new Mac.
#
# What it deliberately does NOT do: compile treesitter parsers or install Mason
# LSP servers. Both happen on first interactive launch. This script only
# guarantees the prerequisites those steps need.
#
# Usage:
#   scripts/bootstrap.sh

set -euo pipefail

# nvim-treesitter's `main` branch shells out to the tree-sitter CLI to compile
# every parser; without it, startup dies with ENOENT on 'tree-sitter'. 0.26.1 is
# the floor that branch requires.
TS_MIN_MAJOR=0
TS_MIN_MINOR=26
TS_MIN_PATCH=1
BIN_DIR="${HOME}/.local/bin"

log() { printf '==> %s\n' "$*"; }
warn() { printf 'warning: %s\n' "$*" >&2; }
die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

# --- tree-sitter CLI.
# True when a tree-sitter on PATH already meets the floor, so a brew or cargo
# install on the Mac wins and we never clobber it.
ts_version_ok() {
  local version major minor patch
  command -v tree-sitter >/dev/null 2>&1 || return 1
  # `tree-sitter --version` prints e.g. "tree-sitter 0.26.12"
  version="$(tree-sitter --version 2>/dev/null | awk '{print $2}')"
  IFS=. read -r major minor patch <<<"$version"
  patch="${patch%%[!0-9]*}" # drop any pre-release/build suffix
  case "$major" in '' | *[!0-9]*) return 1 ;; esac
  case "$minor" in '' | *[!0-9]*) return 1 ;; esac
  case "$patch" in '' | *[!0-9]*) return 1 ;; esac
  # Compare component-wise; the first one that differs decides.
  if [ "$major" -ne "$TS_MIN_MAJOR" ]; then
    [ "$major" -gt "$TS_MIN_MAJOR" ]
  elif [ "$minor" -ne "$TS_MIN_MINOR" ]; then
    [ "$minor" -gt "$TS_MIN_MINOR" ]
  else
    [ "$patch" -ge "$TS_MIN_PATCH" ]
  fi
}

# Upstream publishes both `tree-sitter-<os>-<arch>.gz` (the bare binary) and
# `tree-sitter-cli-<os>-<arch>.zip` (a different artifact). We want the former.
ts_asset() {
  local os arch
  case "$(uname -s)" in
    Linux) os=linux ;;
    Darwin) os=macos ;;
    *) die "unsupported OS for tree-sitter download: $(uname -s)" ;;
  esac
  case "$(uname -m)" in
    x86_64 | amd64) arch=x64 ;;
    arm64 | aarch64) arch=arm64 ;;
    *) die "unsupported arch for tree-sitter download: $(uname -m)" ;;
  esac
  printf 'tree-sitter-%s-%s.gz' "$os" "$arch"
}

# Everything with side effects lives in main, so tests can source this file
# for its functions without bootstrapping anything.
main() {
  # --- Hard prerequisites. Collect every missing one so a fresh box reports them
  # in a single pass. Accumulated as a string, not an array: macOS ships bash 3.2,
  # where `${arr[*]}` on an empty array trips `set -u`.
  local missing=""
  for cmd in nvim git curl tar; do
    command -v "$cmd" >/dev/null 2>&1 || missing="$missing $cmd"
  done
  if ! command -v cc >/dev/null 2>&1 &&
    ! command -v gcc >/dev/null 2>&1 &&
    ! command -v clang >/dev/null 2>&1; then
    missing="$missing cc/gcc/clang"
  fi
  [ -z "$missing" ] || die "missing required tools:$missing"

  if ts_version_ok; then
    log "tree-sitter $(tree-sitter --version | awk '{print $2}') already satisfies >= ${TS_MIN_MAJOR}.${TS_MIN_MINOR}.${TS_MIN_PATCH}"
  else
    local asset tmp
    asset="$(ts_asset)"
    log "installing tree-sitter CLI ($asset) into $BIN_DIR"
    mkdir -p "$BIN_DIR"
    # Debian's packaged tree-sitter-cli lags the 0.26.1 floor, so take the upstream
    # prebuilt binary rather than the distro package. Staged through a temp file
    # so a failed download can't leave a truncated binary in place.
    tmp="$(mktemp)"
    curl -fsSL "https://github.com/tree-sitter/tree-sitter/releases/latest/download/${asset}" |
      gunzip >"$tmp"
    chmod 0755 "$tmp"
    mv "$tmp" "${BIN_DIR}/tree-sitter"
    command -v tree-sitter >/dev/null 2>&1 ||
      warn "${BIN_DIR} is not on PATH — add it so Neovim can find tree-sitter"
  fi

  # --- node. Copilot and the npm-backed Mason servers (bashls, cssls, html,
  # ts_ls, yamlls, pyright, cucumber_language_server) need it at runtime. Not
  # fatal: everything else still works without it.
  command -v node >/dev/null 2>&1 ||
    warn "node not found — Copilot and npm-backed LSP servers will be unavailable"

  # --- Plugins. `Lazy! restore` checks out the lazy-lock.json commits and runs
  # each plugin's build step. Bang suffix = don't wait for input on failure.
  log "restoring plugins from lazy-lock.json"
  nvim --headless "+Lazy! restore" +qa

  log "bootstrap complete"
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  main "$@"
fi

#!/usr/bin/env bash
#
# Build tree-sitter parsers for this Neovim config without nvim-treesitter.
#
# Parsers are compiled into $XDG_DATA_HOME/nvim/site/parser/<lang>.so, which is
# on Neovim's runtimepath. Grammar repos + revisions are pinned in the table
# below — this is the single source of truth that replaces nvim-treesitter's
# lua/nvim-treesitter/parsers.lua.
#
# Provenance / coupling:
#   Grammar pins below AND the vendored queries under ../queries both come from
#   nvim-treesitter @ 4916d659, which was ARCHIVED (read-only) on 2026-04-03 —
#   there will be no further upstream updates. The two halves are version-coupled:
#   when you bump a revision here you MUST re-vendor that language's query dir to
#   match (see queries/README.md, "Updating a language").
#   Grammars lacking a checked-in src/parser.c (swift) are regenerated with the
#   `tree-sitter` CLI; this baseline was built with tree-sitter CLI 0.26.9.
#
# Parsers that ship with Neovim (c, lua, markdown, markdown_inline, query, vim,
# vimdoc) are intentionally omitted.
#
# Usage:
#   scripts/build-parsers.sh                # build all pinned parsers
#   scripts/build-parsers.sh go typescript  # build a subset
#
# Requirements: git, a C compiler (cc). The `tree-sitter` CLI is only needed for
# grammars that don't ship a generated src/parser.c (e.g. swift).

set -euo pipefail

# lang|repo|revision|location|generate
# location: subdir of the repo that contains src/ (and grammar.js); "." for root.
# generate: "1" to force `tree-sitter generate` before compiling.
PARSERS=$(
  cat <<'EOF'
bash|https://github.com/tree-sitter/tree-sitter-bash|a06c2e4415e9bc0346c6b86d401879ffb44058f7|.|0
css|https://github.com/tree-sitter/tree-sitter-css|dda5cfc5722c429eaba1c910ca32c2c0c5bb1a3f|.|0
dockerfile|https://github.com/camdencheek/tree-sitter-dockerfile|971acdd908568b4531b0ba28a445bf0bb720aba5|.|0
go|https://github.com/tree-sitter/tree-sitter-go|2346a3ab1bb3857b48b29d779a1ef9799a248cd7|.|0
hcl|https://github.com/tree-sitter-grammars/tree-sitter-hcl|64ad62785d442eb4d45df3a1764962dafd5bc98b|.|0
html|https://github.com/tree-sitter/tree-sitter-html|73a3947324f6efddf9e17c0ea58d454843590cc0|.|0
javascript|https://github.com/tree-sitter/tree-sitter-javascript|58404d8cf191d69f2674a8fd507bd5776f46cb11|.|0
json|https://github.com/tree-sitter/tree-sitter-json|001c28d7a29832b06b0e831ec77845553c89b56d|.|0
python|https://github.com/tree-sitter/tree-sitter-python|d326e4cad262cf681656e130960e49dfc04c03ea|.|0
# ^ python: immutable commit for tag v0.25.0 (tags are repointable; SHA is not)
ruby|https://github.com/tree-sitter/tree-sitter-ruby|ad907a69da0c8a4f7a943a7fe012712208da6dee|.|0
rust|https://github.com/tree-sitter/tree-sitter-rust|77a3747266f4d621d0757825e6b11edcbf991ca5|.|0
swift|https://github.com/alex-pinkus/tree-sitter-swift|8abb3e8b33256d89127a35e87480736f74755ff9|.|1
terraform|https://github.com/MichaHoffmann/tree-sitter-hcl|64ad62785d442eb4d45df3a1764962dafd5bc98b|dialects/terraform|0
typescript|https://github.com/tree-sitter/tree-sitter-typescript|75b3874edb2dc714fb1fd77a32013d0f8699989f|typescript|0
EOF
)

PARSER_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/parser"
mkdir -p "$PARSER_DIR"

CC="${CC:-cc}"
CXX="${CXX:-c++}"

die() {
  echo "error: $*" >&2
  exit 1
}

command -v git >/dev/null || die "git not found"
command -v "$CC" >/dev/null || die "C compiler '$CC' not found (set \$CC)"

build_one() {
  local lang=$1 repo=$2 rev=$3 location=$4 generate=$5
  local tmp grammar_dir src
  tmp=$(mktemp -d)
  # shellcheck disable=SC2064
  trap "rm -rf '$tmp'" RETURN

  echo ">> $lang  ($repo @ $rev)"
  git clone --quiet --depth 1 "$repo" "$tmp" 2>/dev/null || die "clone failed: $repo"
  # Fetch the exact pinned revision (tags work too); depth 1 clone may not include it.
  if ! git -C "$tmp" cat-file -e "$rev^{commit}" 2>/dev/null; then
    git -C "$tmp" fetch --quiet --depth 1 origin "$rev" 2>/dev/null \
      || die "fetch of revision $rev failed"
  fi
  git -C "$tmp" checkout --quiet "$rev" 2>/dev/null \
    || git -C "$tmp" checkout --quiet FETCH_HEAD 2>/dev/null \
    || die "checkout of $rev failed"

  grammar_dir="$tmp/$location"
  src="$grammar_dir/src"

  if [ "$generate" = "1" ] || [ ! -f "$src/parser.c" ]; then
    command -v tree-sitter >/dev/null \
      || die "$lang needs 'tree-sitter generate' but the tree-sitter CLI is not installed"
    echo "   generating parser.c via tree-sitter CLI"
    ( cd "$grammar_dir" && tree-sitter generate --no-bindings >/dev/null 2>&1 ) \
      || ( cd "$grammar_dir" && tree-sitter generate >/dev/null 2>&1 ) \
      || die "tree-sitter generate failed for $lang"
  fi

  [ -f "$src/parser.c" ] || die "$src/parser.c missing after setup for $lang"

  local sources=("$src/parser.c")
  local compiler="$CC"
  if [ -f "$src/scanner.c" ]; then
    sources+=("$src/scanner.c")
  elif [ -f "$src/scanner.cc" ]; then
    sources+=("$src/scanner.cc")
    compiler="$CXX"
  fi

  "$compiler" -O2 -shared -fPIC -I "$src" "${sources[@]}" \
    -o "$PARSER_DIR/$lang.so" || die "compile failed for $lang"
  echo "   -> $PARSER_DIR/$lang.so"
}

# Resolve which langs to build.
declare -a WANT=("$@")
built=0
while IFS='|' read -r lang repo rev location generate; do
  [ -n "$lang" ] || continue
  case "$lang" in \#*) continue ;; esac  # skip comment lines in the table
  if [ ${#WANT[@]} -gt 0 ]; then
    skip=1
    for w in "${WANT[@]}"; do [ "$w" = "$lang" ] && skip=0; done
    [ "$skip" = 1 ] && continue
  fi
  build_one "$lang" "$repo" "$rev" "$location" "$generate"
  built=$((built + 1))
done <<<"$PARSERS"

if [ ${#WANT[@]} -gt 0 ] && [ "$built" -ne ${#WANT[@]} ]; then
  echo "warning: built $built of ${#WANT[@]} requested — unknown language(s)?" >&2
fi

echo "Done: built $built parser(s) into $PARSER_DIR"

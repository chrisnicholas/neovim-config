# Treesitter queries (vendored)

These query files replace the `nvim-treesitter` core plugin. Neovim loads them
from the runtimepath automatically (`nvim/queries/<lang>/*.scm`), including
`; inherits:` resolution (e.g. `javascript` -> `ecma` + `jsx`).

Highlighting/folding is enabled in `lua/config/treesitter.lua`. Text objects and
sticky context are provided by the `nvim-treesitter-textobjects` and
`nvim-treesitter-context` plugins, which only need parsers + queries on the
runtimepath.

## Why this is vendored

The `nvim-treesitter` **core** plugin (parser install + query management) was
archived (read-only) on 2026-04-03, so this config no longer tracks it — these
queries are a frozen, self-contained baseline. Only the core plugin was archived:
`nvim-treesitter-textobjects` and `nvim-treesitter-context` remain actively
maintained and were rewritten to consume parsers + queries straight from the
runtimepath (no core-plugin dependency), which is exactly the setup here.

## Provenance

Copied from `nvim-treesitter/nvim-treesitter` @ `4916d659` (2026-04-03),
`runtime/queries/`. Vendored language dirs: bash, css, dockerfile, ecma, go,
hcl, html, html_tags, javascript, json, jsx, python, ruby, rust, swift,
terraform, typescript. (c, lua, markdown, markdown_inline, query, vim, vimdoc
ship with Neovim.)

Queries are version-coupled to grammar revisions; the matching grammar pins live
in the `PARSERS` table in `scripts/build-parsers.sh`.

## Updating a language

Rare and user-initiated — there is no upstream to track anymore. To update one
language:

1. Bump its grammar SHA in the `PARSERS` table in `scripts/build-parsers.sh` and
   run `scripts/build-parsers.sh <lang>`.
2. Re-vendor `queries/<lang>/*.scm` to match the new grammar. Sources, in order of
   preference: the grammar repo's own `queries/` (most now ship `highlights.scm`,
   though usually no folds/indents), Neovim core runtime queries, or the
   still-readable (frozen) `nvim-treesitter` tree.
3. Verify: `:checkhealth vim.treesitter` is clean and `:Inspect` on a sample file
   shows `@...` captures — watch for missing highlights or invalid-node errors.

**ABI note:** parsers target tree-sitter ABI ≤15 (fine on Neovim 0.12). A future
major Neovim upgrade that drops an old ABI means re-running
`scripts/build-parsers.sh`; `:checkhealth vim.treesitter` reports ABI mismatches.

## Parsers

Compiled parsers live in `~/.local/share/nvim/site/parser/*.so`. Parser ABI is
stable across Neovim minor releases, so no rebuild is needed until an ABI bump or
a deliberate grammar update.

Build them with the vendored script (no plugin required):

```sh
scripts/build-parsers.sh            # build all pinned parsers
scripts/build-parsers.sh go json    # build a subset
```

Grammar repos and revisions are pinned in the `PARSERS` table at the top of
`scripts/build-parsers.sh` — that table is the single source of truth (it
replaces nvim-treesitter's `parsers.lua`). **When you bump a revision there,
re-vendor the matching language's query dir from a nvim-treesitter commit at the
same grammar revision**, since queries are version-coupled to grammars.

The script already handles the per-language quirks that previously needed manual
`cc` invocations:
- `typescript` builds from the `typescript/` subdir of tree-sitter-typescript.
- `terraform` builds from `dialects/terraform/` of tree-sitter-hcl; `hcl` is a
  separate entry.
- `swift` ships no `parser.c`; the script runs `tree-sitter generate` (requires
  the `tree-sitter` CLI).
- `scanner.c`/`scanner.cc` is compiled in only when the grammar ships one.

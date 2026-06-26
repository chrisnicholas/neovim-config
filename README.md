Neovim configuration files.

## Testing

A small Lua test suite covers the pure-logic parts of the config (path
formatting, visual-selection helpers, LSP utilities, sign priorities, and the
startup debug bootstrap). Tests run headlessly using
[plenary.nvim](https://github.com/nvim-lua/plenary.nvim)'s busted-compatible
runner, which is installed by lazy.nvim.

### Running

```sh
scripts/test.sh                       # run every spec under tests/
scripts/test.sh tests/utils/path_spec.lua  # run a single spec file
```

The runner uses `tests/minimal_init.lua`, which puts plenary and this repo on
the runtimepath *without* loading the full config, so specs start fast and in
isolation. plenary must already be installed (open Neovim once, or run
`:Lazy sync`).

### Layout

Specs live under `tests/`, mirroring the `lua/` tree, and are named
`*_spec.lua`:

```
tests/
├── minimal_init.lua        # runtimepath setup for headless runs
├── config/
│   ├── augroup_spec.lua
│   ├── debug_spec.lua
│   ├── diagnostics_spec.lua
│   ├── lazy_spec.lua
│   └── signs_spec.lua
├── lsp/
│   └── utils_spec.lua
├── plugins/
│   ├── colorschemes/
│   │   └── theme_spec.lua
│   ├── gitsigns_spec.lua
│   └── lsp_spec.lua
└── utils/
    ├── init_spec.lua
    └── path_spec.lua
```

### Writing tests

Specs use plenary's busted API (`describe` / `it` / `assert`). Keep logic
unit-testable by separating it from editor side effects — either as pure
functions (e.g. `lua/utils/path.lua`) or by making side effects injectable via
an `opts` table (e.g. `lua/config/debug.lua`'s `ensure_installed`/`setup`, where
clone/prepend/launch are passed in and stubbed in tests). `vim.*` APIs are
available in the headless runner and can be stubbed per-test when needed (see
`tests/lsp/utils_spec.lua`, which swaps `vim.lsp.get_clients`).

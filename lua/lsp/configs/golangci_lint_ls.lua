--- golangci-lint-langserver configuration
---
--- Reference:
--- - https://github.com/nametake/golangci-lint-langserver
---
--- The server is only a wrapper: it shells out to the real `golangci-lint`
--- binary (installed via ENABLED_MASON_TOOLS in lua/plugins/lsp.lua) and parses
--- its stdout as a single JSON document. Two v2 changes make the default
--- command wrong, so pin it explicitly:
---
--- 1. v2 dropped `--out-format json` in favour of `--output.json.path`, and the
---    langserver won't parse v1-style output from a v2 binary.
--- 2. v2 appends a per-linter stats block ("1 issues:\n* typecheck: 1") *after*
---    the JSON, which is on by default. The langserver's decoder chokes on it
---    with `invalid character '1' after top-level value`, surfacing as a bogus
---    diagnostic in the buffer. `--show-stats=false` suppresses it.
---
--- Gotcha: golangci-lint refuses to run when the Go *language* version (major.
--- minor, so 1.25 vs 1.26 -- patch differences are fine) that built it is older
--- than the `go` directive of the module being linted: "the Go language version
--- used to build golangci-lint is lower than the targeted Go version".
--- Mason installs a tool once and never upgrades it, so a long-lived install
--- drifts behind the Go toolchain and starts failing with that message.
--- Fix with `:MasonInstall golangci-lint` to force a reinstall of the current
--- release.
---@type vim.lsp.Config
local GolangCILintLS = {
  init_options = {
    command = { "golangci-lint", "run", "--output.json.path", "stdout", "--show-stats=false" },
  },
}

return GolangCILintLS

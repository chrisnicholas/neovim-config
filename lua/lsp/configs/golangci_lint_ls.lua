--- golangci-lint-langserver configuration
---
--- Reference:
--- - https://github.com/nametake/golangci-lint-langserver
---
--- The server is only a wrapper: it shells out to the real `golangci-lint`
--- binary (installed via ENABLED_MASON_TOOLS in lua/plugins/lsp.lua) and parses
--- its JSON. golangci-lint v2 dropped `--out-format json` in favour of
--- `--output.json.path`, and the langserver won't parse v1-style output from a
--- v2 binary, so pin the command rather than relying on its default.
---
--- Gotcha: golangci-lint refuses to run when the Go toolchain that built it is
--- older than the `go` directive of the module being linted ("the Go language
--- version used to build golangci-lint is lower than the targeted Go version").
--- Mason installs a tool once and never upgrades it, so a long-lived install
--- drifts behind the Go toolchain and starts failing with that message.
--- Fix with `:MasonInstall golangci-lint` to force a reinstall of the current
--- release.
---@type vim.lsp.Config
local GolangCILintLS = {
  init_options = {
    command = { "golangci-lint", "run", "--output.json.path", "stdout" },
  },
}

return GolangCILintLS

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration written in Lua, using the lazy.nvim plugin manager. The configuration is modular, with separate files for plugins, LSP servers, keymaps, autocommands, and other settings.

## Architecture

### Entry Point
- `init.lua`: Main entry point that loads all configuration modules in order:
  1. `config.opts` - Neovim options and settings
  2. `config.keymap` - Global keymaps
  3. `config.autocmd` - Autocommands for filetype settings
  4. `config.lazy` - Plugin manager initialization

### Plugin Management (lazy.nvim)
- Plugins are lazy-loaded by default (`defaults.lazy = true`)
- Each plugin is defined in a separate file under `lua/plugins/`
- Plugin specs follow the LazyPluginSpec format with `keys`, `cmd`, `event`, etc. for lazy-loading
- `lua/config/lazy.lua`: Bootstraps lazy.nvim and loads all plugins from `lua/plugins/`
- Run `:Lazy` to manage plugins (install, update, clean)

### Directory Structure
```
lua/
├── config/              # Core Neovim configuration
│   ├── augroup.lua      # Augroup definitions
│   ├── autocmd.lua      # Filetype-specific settings
│   ├── diagnostics.lua  # LSP diagnostics configuration
│   ├── keymap.lua       # Global keymaps (file path copy, window nav, scrolling)
│   ├── lazy.lua         # Plugin manager setup
│   ├── opts.lua         # Neovim options
│   └── signs.lua        # Sign/icon priorities (used by DAP, diagnostics)
├── lsp/                 # LSP server configurations
│   ├── configs/         # Per-server custom configs (gopls, lua_ls, etc.)
│   └── utils.lua        # LSP utilities (keymaps, formatting, autocommands)
├── plugins/             # Plugin specifications (one per file)
│   └── colorschemes/    # Color scheme plugins
└── utils/               # Helper utilities
    └── autocmd.lua      # Autocmd helper functions
```

### LSP Configuration
- **Main config**: `lua/plugins/lsp.lua` sets up nvim-lspconfig + mason.nvim
- **Enabled servers**: Listed in `ENABLED_LSP_CONFIGS` table (lua/plugins/lsp.lua:1-14)
- **Custom configs**: Per-server configs go in `lua/lsp/configs/{server}.lua`
  - Only needed if overriding defaults
  - Automatically loaded and merged with defaults
- **LSP behavior**:
  - Keymaps set on `LspAttach` event (lua/lsp/utils.lua:22-32)
  - Auto-format on save (lua/lsp/utils.lua:38-46)
  - Default capabilities include nvim-cmp completion

### Key Plugin Files
- `lua/plugins/lsp.lua`: LSP and Mason configuration
- `lua/plugins/nvim-cmp.lua`: Completion engine with snippet support
- `lua/plugins/telescope.lua`: Fuzzy finder keymaps (`<leader>f*`, `<leader>g*`)
- `lua/plugins/neo-tree.lua`: File explorer (`<leader>fe`, `<leader>ge`, `<leader>be`)
- `lua/plugins/snacks.lua`: Dashboard, indent guides, scope highlighting, terminal toggle
- `lua/plugins/nvim-treesitter.lua`: Treesitter configuration
- `lua/plugins/copilot.lua`: GitHub Copilot (`copilot.vim`) + CopilotChat (`<leader>cc/ce/co/cr`)
- `lua/plugins/dap.lua`: Debug Adapter Protocol — auto-opens dapui on session start; loads `launch.json` for codelldb; includes a Lua DAP adapter via `one-small-step-for-vimkind`

### Keymap Conventions
- `<leader>ff/fg/fb/fh/fs/fn/fd/fa`: Telescope (files, grep, buffers, help, symbols, notifications, diagnostics, autocommands)
- `<leader>gd/gr/gi/gc/gb`: Telescope LSP/git (definitions, references, implementations, commits, branches)
- `<leader>cfp/crp/cfn`: Copy file path to clipboard (absolute, relative, filename only)
  - In visual mode, appends line numbers (e.g., `file.lua:10-15`)
- `<leader>cc/ce/co/cr`: CopilotChat (toggle, explain, optimize, reset) — works in normal and visual
- `<leader>db/dB/dc`: DAP breakpoint (toggle, list, conditional); `<leader>de` evaluate expression; `<leader>dl` launch Lua adapter
- `<F5/10/11/12>`: DAP continue / step over / step into / step out
- `<leader>*e`: Explorers (Neo-tree for files, git, buffers)
- `<leader>tt`: Toggle floating terminal (snacks.nvim)
- `<A-h/j/k/l>`: Window navigation
- Arrow keys: Scrolling (plain) and half-paging (Shift)
- LSP keymaps: `gd`, `gD`, `gi`, `gr`, `<space>D`, `g?` (set on LspAttach — note `<leader>gd/gr/gi` are Telescope variants)

## Adding New Plugins

1. Create a new file in `lua/plugins/` (e.g., `lua/plugins/my-plugin.lua`)
2. Return a LazyPluginSpec table:
```lua
---@type LazyPluginSpec
local M = {
  "author/plugin-name",
  event = "VeryLazy",  -- or cmd, keys, ft for lazy-loading
}

M.opts = {
  -- plugin options
}

-- Optional: custom config function
function M.config(_, opts)
  require("plugin-name").setup(opts)
end

return M
```
3. Restart Neovim - lazy.nvim auto-loads all files in `lua/plugins/`

## Adding/Modifying LSP Servers

1. Add server name to `ENABLED_LSP_CONFIGS` in `lua/plugins/lsp.lua`
2. (Optional) Create custom config in `lua/lsp/configs/{server}.lua`:
```lua
return {
  settings = {
    -- server-specific settings
  }
}
```
3. Mason will auto-install the server on next startup

## Filetype Settings

Filetype-specific settings are in `lua/config/autocmd.lua` using the `autocmd.filetype()` helper.
Example: `autocmd.filetype("go", "setlocal noexpandtab shiftwidth=0 tabstop=4")`

## Testing Changes

- Restart Neovim to reload configuration
- Use `:Lazy sync` to install/update plugins
- Use `:LspInfo` to check LSP server status
- Use `:checkhealth` to diagnose issues
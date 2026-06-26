local ENABLED_LSP_CONFIGS = {
  "bashls",
  "cssls",
  "cucumber_language_server",
  "golangci_lint_ls",
  "gopls",
  "html",
  "lua_ls",
  "marksman",
  "pyright",
  "rust_analyzer",
  "solargraph",
  "tofu_ls",
  "ts_ls",
  "yamlls",
}

---@type LazyPluginSpec
local MasonSpec = {
  "williamboman/mason.nvim",
  cmd = "Mason",
  opts = {},
}

---@type LazyPluginSpec
local MasonLspConfigSpec = {
  "williamboman/mason-lspconfig.nvim",
  opts = {
    ensure_installed = ENABLED_LSP_CONFIGS,
    automatic_installation = true,
  },
}

---@type LazyPluginSpec
local LspConfigSpec = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { MasonSpec, MasonLspConfigSpec },
  cmd = "LspInfo",
}

--- Load a server's custom config from `lua/lsp/configs/<server>.lua`, returning
--- an empty table when the module does not exist. Pure (aside from the require).
function LspConfigSpec.load_custom_config(server)
  local ok, custom_config = pcall(require, ("lsp.configs.%s"):format(server))
  if not ok then
    return {}
  end
  return custom_config
end

--- Merge a server's default config with its custom config; custom keys win,
--- nested tables are deep-merged. Pure.
function LspConfigSpec.merge_server_config(default_config, custom_config)
  return vim.tbl_deep_extend("force", default_config, custom_config)
end

function LspConfigSpec.config(_, opts)
  opts = opts or {}

  -- Diagnostics
  require("config.diagnostics").init()

  -- Set default capabilitites for all LSP servers
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
  vim.lsp.config("*", { capabilities = capabilities })

  -- Enable LSP Configurations
  for _, server in ipairs(ENABLED_LSP_CONFIGS) do
    local default_config = vim.lsp.config[server] or {}
    local custom_config = LspConfigSpec.load_custom_config(server)
    local config = LspConfigSpec.merge_server_config(default_config, custom_config)
    vim.lsp.config(server, config)
  end

  require("lsp.utils").create_lsp_autocommands()
end

return LspConfigSpec

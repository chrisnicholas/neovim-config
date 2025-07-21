local ENABLED_LSP_CONFIGS = {
  "bashls",
  "cucumber_language_server",
  "gopls",
  "golangci_lint_ls",
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

    -- Merge custom config from `/lua/lsp/*.lua` if exists
    local ok, custom_config = pcall(require, ("lsp.configs.%s"):format(server))
    if not ok then
      custom_config = {}
    end

    local config = vim.tbl_deep_extend("force", default_config, custom_config)
    vim.lsp.config(server, config)
  end

  require("lsp.utils").create_lsp_autocommands()
end

return LspConfigSpec

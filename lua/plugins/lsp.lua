local ENABLED_LSP_CONFIGS = {
  "bashls",
  "cucumber_language_server",
  "gopls",
  "golangci_lint_ls",
  "lua_ls",
  "pyright",
  "rust_analyzer",
  "solargraph",
  "terraformls",
  "ts_ls",
}

local function create_lsp_autocommands()
  local cn_lsp = vim.api.nvim_create_augroup("cn-lsp", { clear = true })

  -- Create keymaps which (likely) apply to all servers
  vim.api.nvim_create_autocmd("LspAttach", {
    group = cn_lsp,
    callback = function(event)
      local opts = { buffer = event.buf }

      -- Keymaps
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', 'g?', vim.diagnostic.open_float, opts)
    end,
  })

  -- Format file on save
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = cn_lsp,
    callback = function(event)
      vim.lsp.buf.format({ bufnr = event.buf })
    end,
  })
end

local MasonSpec = {
  "williamboman/mason.nvim",
  cmd = "Mason",
  opts = {},
}

local MasonLspConfigSpec = {
  "williamboman/mason-lspconfig.nvim",
}

MasonLspConfigSpec.opts = {
  ensure_installed = ENABLED_LSP_CONFIGS,
  automatic_installation = true,
}

local LspConfigSpec = {
  'neovim/nvim-lspconfig',
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { MasonSpec, MasonLspConfigSpec },
  cmd = 'LspInfo',
}

function LspConfigSpec.config(_, opts)
  local opts = opts or {}

  -- Diagnostics
  vim.diagnostic.config({ virtual_lines = false, virtual_text = false })

  -- Set default capabilitites
  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  vim.lsp.config("*", { capabilities = capabilities })

  -- Enable LSP Configurations
  for _, server in ipairs(require("mason-lspconfig").get_installed_servers()) do
    local default_config = vim.lsp.config[server] or {}

    -- Merge custom config from `/lua/lsp/*.lua` if exists
    local ok, custom_config = pcall(require, ("lsp.configs.%s"):format(server))
    if not ok then
      custom_config = {}
    end

    local config = vim.tbl_deep_extend("force", default_config, custom_config)
    vim.lsp.config(server, config)
  end

  create_lsp_autocommands()
end

return {
  LspConfigSpec,
}

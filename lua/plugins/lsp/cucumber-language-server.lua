local M = {}

function M.init(on_attach, capabilities)
  local lspconfig = require('lspconfig')

  lspconfig.cucumber_language_server.setup({
    cmd = { "cucumber-language-server", "--stdio" },
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "cucumber", "feature" },
    root_dir = lspconfig.util.root_pattern("features"),
    settings = {
      cucumber = {
        steps = { "features/**/*.rb" } -- Adjust the path as needed
      }
    }
  })
end

return M

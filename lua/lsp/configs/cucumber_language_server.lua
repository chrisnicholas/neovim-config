--- CucumberLS configuration
---
---@type vim.lsp.ClientConfig
local CucumberLS = {
  cmd = { "cucumber-language-server", "--stdio" },
  filetypes = { "cucumber", "feature" },
  settings = {
    cucumber = {
      steps = { "features/**/*.rb" } -- Adjust the path as needed
    }
  }
}

return CucumberLS

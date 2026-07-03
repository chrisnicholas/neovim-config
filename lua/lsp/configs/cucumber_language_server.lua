--- CucumberLS configuration
---
---@type vim.lsp.Config
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

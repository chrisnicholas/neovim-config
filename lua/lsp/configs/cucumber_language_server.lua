local M = {
  cmd = { "cucumber-language-server", "--stdio" },
  filetypes = { "cucumber", "feature" },
  settings = {
    cucumber = {
      steps = { "features/**/*.rb" } -- Adjust the path as needed
    }
  }
}

return M

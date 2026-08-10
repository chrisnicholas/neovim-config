local M = {
  -- Opens a preview in a real browser, and its `build` step needs node+yarn.
  -- Neither holds on the headless cnserver box, where the build fails during
  -- provisioning and the preview server would be unreachable anyway. Boolean,
  -- not a function: tests/plugins/conventions_spec.lua requires it.
  enabled = require("utils.env").has_browser(),
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app && yarn install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
  ft = { "markdown" },
}

return M

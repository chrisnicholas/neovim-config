local M = {
  "CopilotC-Nvim/CopilotChat.nvim",
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  build = "make tiktoken", -- Only on MacOS or Linux
}

M.dependencies = {
  { "github/copilot.vim" },
  { "nvim-lua/plenary.nvim", branch = "master" },
}

M.opts = {
  highlight_headers = true,
  window = {
    layout = 'float',
    width = 0.5,
    height = 0.9,
    row = nil,
    col = nil,
  },
}

M.keys = {
  { '<leader>cc', '<CMD>CopilotChatToggle<CR>', mode = {'n', 'v'} },
  { '<leader>ce', '<CMD>CopilotChatExplain<CR>', mode = {'n', 'v'} },
  { '<leader>co', '<CMD>CopilotChatOptimize<CR>', mode = {'n', 'v'} },
}

return M

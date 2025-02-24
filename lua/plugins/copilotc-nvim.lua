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
  window = {
    layout = 'float',
    width = 0.5,
    height = 0.9,
    row = nil,
    col = nil,
  },
  show_help = true, -- Shows help message as virtual lines when waiting for user input
  show_folds = true, -- Shows folds for sections in chat
  highlight_selection = true, -- Highlight selection
  highlight_headers = true, -- Highlight headers in chat, disable if using markdown renderers (like render-markdown.nvim)
  auto_follow_cursor = true, -- Auto-follow cursor in chat
  auto_insert_mode = false, -- Automatically enter insert mode when opening window and on new prompt
  insert_at_end = true, -- Move cursor to end of buffer when inserting text
  clear_chat_on_new_prompt = false, -- Clears chat on every new prompt
  chat_autocomplete = true, -- Enable chat autocompletion (when disabled, requires manual `mappings.complete` trigger)
  mappings = {
    complete = {
      insert = '',
    },
    close = {
      normal = 'q',
      insert = '<C-c>',
    },
    reset = {
      normal = '<C-l>',
      insert = '<C-l>',
    },
    submit_prompt = {
      normal = '<CR>',
      insert = '<C-s>',
    },
    toggle_sticky = {
      detail = 'Makes line under cursor sticky or deletes sticky line.',
      normal = 'gr',
    },
    accept_diff = {
      normal = '<C-y>',
      insert = '<C-y>',
    },
    jump_to_diff = {
      normal = 'gj',
    },
    quickfix_answers = {
      normal = 'gqa',
    },
    quickfix_diffs = {
      normal = 'gqd',
    },
    yank_diff = {
      normal = 'gy',
      register = '"', -- Default register to use for yanking
    },
    show_diff = {
      normal = 'gd',
      full_diff = false, -- Show full diff instead of unified diff when showing diff window
    },
    show_info = {
      normal = 'gi',
    },
    show_context = {
      normal = 'gc',
    },
    show_help = {
      normal = 'gh',
    },
  },
}

M.keys = {
  { '<leader>cc', '<CMD>CopilotChatToggle<CR>', mode = {'n', 'v'} },
  { '<leader>ce', '<CMD>CopilotChatExplain<CR>', mode = {'n', 'v'} },
  { '<leader>co', '<CMD>CopilotChatOptimize<CR>', mode = {'n', 'v'} },
  { '<leader>cr', '<CMD>CopilotChatReset<CR>', mode = {'n'} },
}

return M

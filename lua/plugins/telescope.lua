local M = {}

function M.init()
  return {
    'nvim-telescope/telescope.nvim',
    dependencies = { {'nvim-lua/plenary.nvim'} },
    cmd = { 'Telescope' },
    keys = M.keymaps,
    config = M.config
  }
end

function M.keymaps()
  return {
    {
      "<leader>ff",
      function()
        require('telescope.builtin').find_files()
      end,
      desc = "Find Files"
    },
    {
      "<leader>fg",
      function()
        require('telescope.builtin').live_grep()
      end,
      desc = "Live Grep"
    },
    {
      "<leader>fb",
      function()
        require('telescope.builtin').buffers()
      end,
      desc = "Find Buffers"
    },
    {
      "<leader>fh",
      function()
        require('telescope.builtin').help_tags()
      end,
      desc = "Help Tags"
    },
    {
      "<leader>fn",
      function()
        require("telescope").load_extension('notify')
        require('telescope').extensions.notify.notify()
      end,
      desc = "Notification History"
    }
  }
end

function M.config()
  require('telescope').setup()
end

return M.init()

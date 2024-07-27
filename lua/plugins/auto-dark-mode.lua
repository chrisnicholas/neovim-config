return {
  'f-person/auto-dark-mode.nvim',
  lazy = false,
  opts = {
    update_interval = 1000,
    set_dark_mode = function()
      vim.api.nvim_set_option('background', 'dark')
      vim.cmd.colorscheme('github_dark_default')
    end,
    set_light_mode = function()
      vim.api.nvim_set_option('background', 'light')
      vim.cmd.colorscheme('github_light_default')
    end,
  },
}

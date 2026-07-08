local group_config = require("config.augroup").nvim_opts
local opts_augroup = vim.api.nvim_create_augroup(group_config.name, group_config.opts)

-- Line Numbers
vim.opt.number = true
vim.opt.numberwidth = 5
vim.opt.signcolumn = "auto:1-4"

-- Hilight current line (active window only)
require("config.cursorline").setup({ group = opts_augroup })

-- Let Neovim set the terminal title
vim.opt.title = true
vim.api.nvim_create_autocmd({ "BufEnter", "DirChanged" }, {
  group = opts_augroup,
  callback = function()
    vim.opt.titlestring = require("config.title").titlestring()
  end
})

-- Mouse
vim.opt.mouse = "a"

-- Word wrap
vim.opt.wrap = false

vim.opt.completeopt = "menu"

-- Color Column(s)
vim.opt.colorcolumn = "120"

-- Disable remote plugin providers
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

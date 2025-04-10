-- Line Numbers
vim.opt.number = true
vim.opt.numberwidth = 5
vim.opt.signcolumn = 'yes'

-- Let Neovim set the terminal title
vim.opt.title = true
vim.opt.titlestring = [[%f %h%m%r%w %{v:progname} (%{tabpagenr()} of %{tabpagenr('$')})]]

-- Mouse
vim.opt.mouse = 'a'

-- Word wrap
vim.opt.wrap = false

vim.opt.completeopt = 'menu'

-- Color Column(s)
vim.opt.colorcolumn = '120'

-- Disable remote plugin providers
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

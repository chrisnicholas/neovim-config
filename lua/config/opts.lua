-- Options
vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.wrap = false
vim.opt.completeopt = 'menu'
vim.opt.colorcolumn = '120'

-- Code Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = -1
vim.opt.foldenable = true

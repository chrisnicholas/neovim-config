-- Select window with <option> + h,j,k,l
vim.keymap.set("n", "<A-k>", "<C-w>k")
vim.keymap.set("n", "<A-j>", "<C-w>j")
vim.keymap.set("n", "<A-h>", "<C-w>h")
vim.keymap.set("n", "<A-l>", "<C-w>l")

-- Scroll with arrow keys
vim.keymap.set("n", "<Up>", "<c-y>")
vim.keymap.set("n", "<Down>", "<c-e>")
vim.keymap.set("n", "<Left>", "zh")
vim.keymap.set("n", "<Right>", "zl")

-- Half-paging with arrow keys
vim.keymap.set("n", "<S-Up>", "<c-u>")
vim.keymap.set("n", "<S-Down>", "<c-d>")
vim.keymap.set("n", "<S-Left>", "zH")
vim.keymap.set("n", "<S-Right>", "zL")

-- Copying file paths to system clipboard (<leader>cfp/crp/cfn)
require("config.pathcopy").setup()

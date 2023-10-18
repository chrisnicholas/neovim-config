local utils = require('utils.keymap')
local nmap = utils.nmap

-- Select window with <option> + h,j,k,l
nmap("<A-k>", "<C-w>k")
nmap("<A-j>", "<C-w>j")
nmap("<A-h>", "<C-w>h")
nmap("<A-l>", "<C-w>l")

-- Scroll with arrow keys
nmap("<Up>", "<c-y>")
nmap("<Down>", "<c-e>")
nmap("<Left>", "zh")
nmap("<Right>", "zl")

-- Half-paging with arrow keys
nmap("<S-Up>", "<c-u>")
nmap("<S-Down>", "<c-d>")
nmap("<S-Left>", "zH")
nmap("<S-Right>", "zL")

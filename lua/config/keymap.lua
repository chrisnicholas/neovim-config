local utils = require('utils.keymap')
local nmap = utils.nmap

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

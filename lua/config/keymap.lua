local keymap = require('utils.keymap')
local nmap = keymap.nmap

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

-- Copying file paths to system clipboard
local function copy_file_path_to_clip_board(expansion)
  vim.fn.setreg("+", vim.fn.expand(expansion))
end

local function copy_absolute_path_to_clipboard()
  copy_file_path_to_clip_board("%:p")
end

nmap("<leader>cfp", copy_absolute_path_to_clipboard)

local function copy_relative_path_to_clipboard()
  copy_file_path_to_clip_board("%:.")
end

nmap("<leader>crp", copy_relative_path_to_clipboard)

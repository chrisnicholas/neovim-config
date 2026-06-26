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

-- Copying file paths to system clipboard
local path = require("utils.path")

local function copy_file_path_to_clip_board(expansion)
  local file_path = vim.fn.expand(expansion)

  -- In visual mode, append the selected line range (see utils.path).
  local mode = vim.fn.mode()
  local visual_block = vim.api.nvim_replace_termcodes('<C-v>', true, true, true)
  local is_visual = mode == "v" or mode == "V" or mode == visual_block

  local start_pos = vim.fn.getpos("v")
  local end_pos = vim.fn.getpos(".")
  file_path = path.format_path(file_path, is_visual, start_pos[2], end_pos[2])

  vim.fn.setreg("+", file_path)
end

local function copy_absolute_path_to_clipboard()
  copy_file_path_to_clip_board("%:p")
end

vim.keymap.set({ "n", "v" }, "<leader>cfp", copy_absolute_path_to_clipboard)

local function copy_relative_path_to_clipboard()
  copy_file_path_to_clip_board("%:.")
end

vim.keymap.set({ "n", "v" }, "<leader>crp", copy_relative_path_to_clipboard)

local function copy_filename_to_clipboard()
  copy_file_path_to_clip_board("%:t")
end

vim.keymap.set({ "n", "v" }, "<leader>cfn", copy_filename_to_clipboard)

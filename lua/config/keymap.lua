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
local function copy_file_path_to_clip_board(expansion)
  local file_path = vim.fn.expand(expansion)

  -- Check if we're in visual mode and add line numbers
  local mode = vim.fn.mode()
  local visual_block = vim.api.nvim_replace_termcodes('<C-v>', true, true, true)
  if mode == "v" or mode == "V" or mode == visual_block then -- visual, visual-line, visual-block
    -- Get visual selection start and end positions
    local start_pos = vim.fn.getpos("v")
    local end_pos = vim.fn.getpos(".")

    local start_line = math.min(start_pos[2], end_pos[2])
    local end_line = math.max(start_pos[2], end_pos[2])

    if start_line == end_line then
      file_path = file_path .. ":" .. start_line
    else
      file_path = file_path .. ":" .. start_line .. "-" .. end_line
    end
  end

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

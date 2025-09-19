local group_config = require("config.augroup").nvim_opts
local opts_augroup = vim.api.nvim_create_augroup(group_config.name, group_config.opts)

local function set_titlestring()
  local titlestring = ""
  local program_name = vim.v.progname
  local current_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":~:.:t")
  local current_file = vim.fn.expand("%:~:.")
  local current_tab = vim.fn.tabpagenr()
  local total_tabs = vim.fn.tabpagenr("$")
  local file_props = "%h%m%r%w" -- h: titlestring

  if vim.fn.expand("%:p") == "" then
    titlestring = string.format("[%s] %s", program_name, current_dir)
  else
    titlestring = string.format("[%s] %s -- %s %s", program_name, current_dir, current_file, file_props)
  end

  if total_tabs > 1 then
    titlestring = string.format("%s (Tab %d of %d)", titlestring, current_tab, total_tabs)
  end

  return titlestring
end

-- Line Numbers
vim.opt.number = true
vim.opt.numberwidth = 5
vim.opt.signcolumn = "auto:1-4"

-- Hilight current line
vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter" }, {
  group = opts_augroup,
  callback = function(event)
    local bufnr = event.buf
    local ft = vim.bo[bufnr].filetype
    local is_floating = vim.api.nvim_win_get_config(0).relative ~= ""

    if is_floating or ft == "TelescopePrompt" or ft == "snacks_dashboard" then
      vim.opt_local.cursorline = false
    else
      vim.opt_local.cursorline = true
    end
  end,
})

vim.api.nvim_create_autocmd("WinLeave", {
  group = opts_augroup,
  callback = function()
    vim.opt_local.cursorline = false
  end,
})

-- Let Neovim set the terminal title
vim.opt.title = true
vim.api.nvim_create_autocmd({ "BufEnter", "DirChanged" }, {
  group = opts_augroup,
  callback = function()
    vim.opt.titlestring = set_titlestring()
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

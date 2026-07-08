local M = {}

-- Build the terminal title: "[prog] cwd", plus the current file and its
-- status flags when one is open, plus the tab position when tabs are in use.
function M.titlestring()
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

return M

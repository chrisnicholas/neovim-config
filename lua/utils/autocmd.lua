local M = {}

function M.autocmd(autocmd_type, pattern, command)
  vim.api.nvim_create_autocmd(autocmd_type, {
    pattern = pattern,
    command = command
  })
end

function M.filetype(pattern, command)
  M.autocmd("FileType", pattern, command)
end

return M

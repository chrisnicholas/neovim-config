local M = {}

function M.get_visual_selection()
  local in_visual_mode = vim.fn.mode() == 'V' or vim.fn.mode() == 'v'
  local visual_start = vim.fn.line('v')
  local visual_end = vim.fn.line('.')

  if in_visual_mode then
    return { visual_start, visual_end }
  end

  return nil
end

return M

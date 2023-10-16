local M = {
  module_name = ... or 'colorschemes',
  colorscheme_path = vim.fn.stdpath('config')..'/lua/plugins/colorschemes'
}

function M.find_lua_files(f)
  local is_lua_file = string.match(f, '.lua$') ~= nil
  local is_not_init_file = f ~= 'init.lua'
  return is_lua_file and is_not_init_file
end

function M.config()
  local colorscheme_specs = {}
  for _, file in ipairs(vim.fn.readdir(M.colorscheme_path, M.find_lua_files)) do
    local colorscheme_spec = string.match(file, '(.+).lua$')
    table.insert(colorscheme_specs, require(M.module_name..'.'..colorscheme_spec))
  end
  return colorscheme_specs
end

return M.config()

-- Mode <-> colorscheme mapping for auto-dark-mode. Kept separate from the
-- colorscheme plugin spec (init.lua) so the wiring is unit-testable: the
-- applier is injectable, so set_mode can be tested without touching the editor.
local M = {}

M.colorschemes = {
  light = 'github_light_default',
  dark = 'github_dark_dimmed',
}

-- Apply the colorscheme for `mode` ('light' | 'dark'). `apply` defaults to the
-- real editor setter but can be injected in tests.
function M.set_mode(mode, apply)
  apply = apply or M.apply
  apply(M.colorschemes[mode], mode)
end

function M.apply(colorscheme, variant)
  vim.api.nvim_set_option_value('background', variant, {})
  vim.cmd.colorscheme(colorscheme)
end

return M

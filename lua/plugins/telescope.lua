local M = {
  'nvim-telescope/telescope.nvim',
  cmd = { 'Telescope' },
}

M.keys = {
  { '<leader>ff', '<CMD>Telescope find_files<CR>',           desc = 'Find Files' },
  { '<leader>fg', '<CMD>Telescope live_grep<CR>',            desc = 'Live Grep' },
  { '<leader>fb', '<CMD>Telescope buffers<CR>',              desc = 'Find Buffers' },
  { '<leader>fh', '<CMD>Telescope help_tags<CR>',            desc = 'Help Tags' },
  { '<leader>fs', '<CMD>Telescope lsp_document_symbols<CR>', desc = 'Document Symbols' },
  { '<leader>fn', '<CMD>Telescope notify<CR>',               desc = 'Notification History' },
  { '<leader>fd', '<CMD>Telescope diagnostics<CR>',          desc = 'LSP Diagnostics' },
  { '<leader>gd', '<CMD>Telescope lsp_definitions<CR>',      desc = 'LSP Definitions' },
  { '<leader>gr', '<CMD>Telescope lsp_references<CR>',       desc = 'LSP References' },
  { '<leader>gi', '<CMD>Telescope lsp_implementations<CR>',  desc = 'LSP Implementations' },
  { '<leader>gc', '<CMD>Telescope git_commits<CR>',          desc = 'Git Commits' },
  { '<leader>gb', '<CMD>Telescope git_branches<CR>',         desc = 'Git Branches' },
  { '<leader>fa', '<CMD>Telescope autocommands<CR>',         desc = 'Autocommands' },
}

-- Width calculation helpers for LSP pickers
-- Note: fname_width (40%) + symbol_width (50%) = 90%, leaving 10% for margins
local function fname_width_40(_, max_width, _)
  return math.floor(max_width * 0.4)
end

local function fname_width_50(_, max_width, _)
  return math.floor(max_width * 0.5)
end

local function symbol_width_50(_, max_width, _)
  return math.floor(max_width * 0.5)
end

M.opts = {
  defaults = {
    layout_strategy = 'flex',
    sorting_strategy = 'ascending',
    layout_config = {
      prompt_position = 'top',
      flip_columns = 250,
      flip_lines = 40,
      width = 0.95,           -- Use 95% of available width
      height = 0.95,          -- Use 95% of available height
      preview_cutoff = 120,   -- Show preview when window is wider than this
      horizontal = {
        preview_width = 0.55, -- Preview takes 55% in horizontal mode
      },
      vertical = {
        preview_height = 0.5, -- Preview takes 50% in vertical mode
      },
    },
  },
  pickers = {
    lsp_document_symbols = {
      fname_width = fname_width_40,
      symbol_width = symbol_width_50,
    },
    lsp_dynamic_workspace_symbols = {
      fname_width = fname_width_40,
      symbol_width = symbol_width_50,
    },
    lsp_references = {
      fname_width = fname_width_50,
    },
    lsp_definitions = {
      fname_width = fname_width_50,
    },
    lsp_implementations = {
      fname_width = fname_width_50,
    },
  },
}

return M

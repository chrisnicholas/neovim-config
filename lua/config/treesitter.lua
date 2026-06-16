-- Treesitter enablement using only Neovim's built-in API.
-- Parsers live in site/parser/ and queries are vendored under nvim/queries/.
-- (Replaces the nvim-treesitter core plugin; see queries/ and the
-- nvim-treesitter-{textobjects,context} plugin specs for the rest.)

-- Enable treesitter highlighting and per-window expr-folding for normal file
-- buffers. Indentation is left to Neovim's built-in filetype indent scripts.
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = -1
vim.opt.foldenable = true

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("config_treesitter", { clear = true }),
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "" then return end
    if pcall(vim.treesitter.start, args.buf) then
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end
  end,
})

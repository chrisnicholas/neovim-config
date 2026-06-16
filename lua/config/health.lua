local health = vim.health

local parsers = {
  "bash", "c", "css", "dockerfile", "go", "html", "javascript", "json",
  "lua", "markdown", "markdown_inline", "python", "query", "ruby", "rust",
  "swift", "terraform", "typescript", "vim", "vimdoc",
}

return {
  check = function()
    health.start("Treesitter parsers")
    local missing = {}
    for _, lang in ipairs(parsers) do
      if #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".so", false) > 0 then
        health.ok(lang)
      else
        health.warn(lang .. " parser not found — see queries/README.md for build instructions")
        table.insert(missing, lang)
      end
    end
    if #missing == 0 then
      health.info("All parsers present. Re-copy queries/ from nvim-treesitter when rebuilding a parser at a new grammar revision.")
    end
  end,
}

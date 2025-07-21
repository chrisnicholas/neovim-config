local autocmd = require('utils.autocmd')

-- Filetype options
autocmd.filetype("go", "setlocal noexpandtab shiftwidth=0 tabstop=4")
autocmd.filetype("html", "setlocal expandtab shiftwidth=2 tabstop=2")
autocmd.filetype({ "javascript", "json" }, "setlocal expandtab shiftwidth=2 tabstop=2")
autocmd.filetype("css", "setlocal expandtab shiftwidth=2 tabstop=2")
autocmd.filetype("lua", "setlocal expandtab shiftwidth=2 tabstop=2")
autocmd.filetype("markdown", "setlocal wrap linebreak colorcolumn=78")
autocmd.filetype({ "ruby", "eruby" }, "setlocal expandtab shiftwidth=2 tabstop=2")

autocmd.autocmd({ "BufNewFile", "BufRead" }, "*.pryrc", "setlocal syntax=ruby expandtab shiftwidth=2 tabstop=2 ft=ruby")

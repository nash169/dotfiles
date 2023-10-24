local opt = vim.opt

-- show relative line numbers
opt.relativenumber = true

-- shows absolute line number on cursor line (when relative number is on)
opt.number = true

-- 2 spaces for indent width
opt.shiftwidth = 4

-- linebreak for latex (wrap is enabled by default)
opt.linebreak = true

-- highlight the current cursor line``
opt.cursorline = true

-- Disable autocomment newline (lua way of doing it does not work)
vim.cmd("autocmd BufEnter * set formatoptions-=cro")
vim.cmd("autocmd BufEnter * setlocal formatoptions-=cro")

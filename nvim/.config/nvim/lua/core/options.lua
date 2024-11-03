local opt = vim.opt

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
vim.schedule(function()
    opt.clipboard = "unnamedplus"
end)

-- shows absolute line number on cursor line (when relative number is on)
opt.number = true

--- disable wrap
opt.wrap = false

-- 2 spaces for indent width
opt.shiftwidth = 4

-- highlight the current cursor line``
opt.cursorline = true

-- Disable autocomment newline (lua way of doing it does not work)
vim.cmd("autocmd BufEnter * set formatoptions-=cro")
vim.cmd("autocmd BufEnter * setlocal formatoptions-=cro")

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

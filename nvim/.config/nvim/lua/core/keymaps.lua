-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
local map = function(keys, func, desc, mode)
	mode = mode or "n"
	vim.keymap.set(mode, keys, func, { noremap = true, silent = true, desc = desc })
end

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- buffer
map("<Tab>", ":bnext<CR>", "Move to next buffer")
map("<S-Tab>", ":bprevious<CR>", "Move to previous buffer")
map("<leader>bq", ":bprevious | bd #<CR>", "[B]uffer [Q]uit")
map("<leader>bn", ":enew<CR>", "[B]uffer [N]ew")

-- toogle linebreak
map("<leader>lb", ":set wrap! linebreak!<CR>", "[L]ine [B]reak")

-- toggle relative number
map("<leader>nr", ":set relativenumber!<CR>", "[N]umber [R]elative")

-- window
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "[S]plit [V]ertically" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "[S]plit [H]orizontally" })
vim.keymap.set("n", "<leader>sq", "<cmd>close<CR>", { desc = "[S]plit [Q]uit" })
vim.keymap.set("n", "<C-,>", ":vertical resize -2<CR>")
vim.keymap.set("n", "<C-.>", ":vertical resize +2<CR>")

-- move text up and down
map("<S-j>", ":m .+1<CR>==", "Move line down")
map("<S-k>", ":m .-2<CR>==", "Move line up")
map("<S-j>", ":m '>+1<CR>gv=gv", "Move selection up", "v")
map("<S-k>", ":m '<-2<CR>gv=gv", "Move selection down", "v")

-- use jk to exit insert mode
vim.keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- close all
map("<leader>x", ":qa<CR>", "Close all")

-- indent without leaving visual mode
map(">", ">gv", "Add indentation in visual mode", "v")
map("<", "<gv", "Remove indentation in visual mode", "v")

-- insert new blank line below/above without entering in insert mode
-- map("<CR>", "o<Esc>", "Add blank line below", "n")
-- map("<S-CR>", "O<Esc>", "Add blank line above", "n")
vim.keymap.set("n", "gO", "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>k")
vim.keymap.set("n", "go", "<Cmd>call append(line('.'),     repeat([''], v:count1))<CR>j")

vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostics in a floating window" })

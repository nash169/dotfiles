-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
local map = function(keys, func, desc, mode)
	mode = mode or "n"
	vim.keymap.set(mode, keys, func, { noremap = true, silent = true, desc = desc })
end

-- base
map("jk", "<ESC>", "Exit insert mode with jk", "i")
map("<leader>x", ":qa<CR>", "Close all")
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
map("<Esc><Esc>", "<C-\\><C-n>", "Exit terminal mode", "t")
map("<Esc>", "<cmd>nohlsearch<CR>", "Clear highlights on search when pressing <Esc> in normal mode")

-- buffer
map("<Tab>", ":bnext<CR>", "Move to next buffer")
map("<S-Tab>", ":bprevious<CR>", "Move to previous buffer")
map("<leader>bq", ":bprevious | bd #<CR>", "[B]uffer [Q]uit")
map("<leader>bn", ":enew<CR>", "[B]uffer [N]ew")

-- view
map("<leader>lb", ":set wrap! linebreak!<CR>", "[L]ine [B]reak")
map("<leader>nr", ":set relativenumber!<CR>", "[N]umber [R]elative")
map("<leader>nh", ":set number! norelativenumber<CR>", "[N]umber [H]ide")

-- window
map("<C-h>", "<C-w><C-h>", "Move focus to the left window")
map("<C-l>", "<C-w><C-l>", "Move focus to the right window")
map("<C-j>", "<C-w><C-j>", "Move focus to the lower window")
map("<C-k>", "<C-w><C-k>", "Move focus to the upper window")
map("<leader>sv", "<C-w>v", "[S]plit [V]ertically")
map("<leader>sh", "<C-w>s", "[S]plit [H]orizontally")
map("<leader>sq", "<cmd>close<CR>", "[S]plit [Q]uit")
map("<A-h>", ":vertical resize -2<CR>", "Vertical decrease window size")
map("<A-l>", ":vertical resize +2<CR>", "Vertical increase window size")
map("<A-j>", ":horizontal resize -2<CR>", "Horizontal decrease window size")
map("<A-k>", ":horizontal resize +2<CR>", "Horizontal increase window size")

-- editing
map("<A-u>", ":m .+1<CR>==", "Move line up")
map("<A-d>", ":m .-2<CR>==", "Move line down")
map("<A-u>", ":m '>+1<CR>gv=gv", "Move selection up", "v")
map("<A-d>", ":m '<-2<CR>gv=gv", "Move selection down", "v")
map(">", ">gv", "Add indentation in visual mode", "v")
map("<", "<gv", "Remove indentation in visual mode", "v")
map("gO", "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>k", "Add blank line below", "n")
map("go", "<Cmd>call append(line('.'),     repeat([''], v:count1))<CR>j", "Add blank line above", "n")

-- diagnostic
map("<leader>dd", vim.diagnostic.open_float, "Show [D]iagnostics in a floating window", "n")
map("<leader>dl", vim.diagnostic.setloclist, "Open [D]iagnostic quickfix [L]ist", "n")

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- use jk to exit insert mode
keymap("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- Clear highlights on search when pressing <Esc> in normal mode
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- navigate buffers
keymap("n", "<C-i>", ":bnext<CR>", opts)
keymap("n", "<C-o>", ":bprevious<CR>", opts)

-- Move text up and down
keymap("n", "<S-j>", ":m .+1<CR>==", opts)
keymap("n", "<S-k>", ":m .-2<CR>==", opts)
keymap("v", "<S-j>", ":m '>+1<CR>gv=gv", opts)
keymap("v", "<S-k>", ":m '<-2<CR>gv=gv", opts)

-- split window vertically
keymap("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })

-- split window horizontally
keymap("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })

-- close current split window
keymap("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- toogle linebreak
keymap('n', '<A-b>', ':set wrap! linebreak!<CR>', opts)

-- buffer nav
keymap('n', '<S-Tab>', ':bprevious<CR>', opts)


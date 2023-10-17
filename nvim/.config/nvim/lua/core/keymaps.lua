vim.g.mapleader = " "
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- use jk to exit insert mode
keymap("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Navigate buffers
-- keymap("n", "<S-j>", ":bnext<CR>", opts)
-- keymap("n", "<S-k>", ":bprevious<CR>", opts)

-- Move text up and down
keymap("n", "<A-j>", ":m .+1<CR>==", opts)
keymap("n", "<A-k>", ":m .-2<CR>==", opts)

-- split window vertically
keymap("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })

-- split window horizontally
keymap("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })

-- close current split window
keymap("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

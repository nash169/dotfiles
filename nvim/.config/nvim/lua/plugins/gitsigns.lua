return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("gitsigns").setup({
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns
                local map = vim.keymap.set

                map("n", "<A-j>", gs.next_hunk, { desc = "Go to next hunk" })
                map("n", "<A-k>", gs.prev_hunk, { desc = "Go to previous hunk" })
                map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
                map("n", "<leader>hh", gs.preview_hunk, { desc = "Preview hunk" })
            end,
        })
    end,
}

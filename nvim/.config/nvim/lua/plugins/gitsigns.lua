return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("gitsigns").setup({
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns
                local map = vim.keymap.set

                map("n", "<leader>hn", gs.next_hunk)
                map("n", "<leader>hp", gs.prev_hunk)
                map("n", "<leader>hr", gs.reset_hunk)
                map("n", "<leader>lb", gs.blame_line)
            end,
        })
    end,
}

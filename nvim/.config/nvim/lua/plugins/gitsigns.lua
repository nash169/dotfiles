-- Here is a more advanced example where we pass configuration
-- options to `gitsigns.nvim`. This is equivalent to the following Lua:
--    require('gitsigns').setup({ ... })
--
-- See `:help gitsigns` to understand what the configuration keys do
return { -- Adds git related signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    -- event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("gitsigns").setup({
            -- signs = {
            -- 	add = { text = "+" },
            -- 	change = { text = "~" },
            -- 	delete = { text = "_" },
            -- 	topdelete = { text = "‾" },
            -- 	changedelete = { text = "~" },
            -- },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns
                vim.keymap.set("n", "<leader>hn", gs.next_hunk, { desc = "[H]unk [N]ext" })
                vim.keymap.set("n", "<leader>hp", gs.prev_hunk, { desc = "[H]unk [P]revious" })
                vim.keymap.set("n", "<leader>hr", gs.reset_hunk, { desc = "[H]unk [R]eset" })
                vim.keymap.set("n", "<leader>hh", gs.preview_hunk, { desc = "[H]unk [P]review" })
            end,
        })
    end,
}

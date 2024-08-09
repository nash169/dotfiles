return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        require("toggleterm").setup({
            open_mapping = [[<leader>tt]],
            direction = "float",
            insert_mappings = false, -- whether or not the open mapping applies in insert mode
        })

        local Terminal = require("toggleterm.terminal").Terminal

        -- lazygit autoopen
        local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })

        function _LAZYGIT_TOGGLE()
            lazygit:toggle()
        end

        vim.keymap.set("n", "<leader>gg", _LAZYGIT_TOGGLE, { noremap = true })
    end,
}

return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        require("toggleterm").setup({
            open_mapping = [[<A-t>]],
            direction = "float",
        })

        local Terminal = require("toggleterm.terminal").Terminal

        -- lazygit autoopen
        local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })

        function _LAZYGIT_TOGGLE()
            lazygit:toggle()
        end

        vim.keymap.set("n", "<A-g>", _LAZYGIT_TOGGLE, { noremap = true })
    end,
}

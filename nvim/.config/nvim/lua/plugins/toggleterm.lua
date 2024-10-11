return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        require("toggleterm").setup({
            open_mapping = [[<a-;>]],
            direction = "float",
            insert_mappings = false, -- whether or not the open mapping applies in insert mode
        })

        local Terminal = require("toggleterm.terminal").Terminal

        -- lazygit autoopen
        local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })

        function _LAZYGIT_TOGGLE()
            lazygit:toggle()
        end

        vim.keymap.set("n", "<a-'>", _LAZYGIT_TOGGLE, { noremap = true })
    end,
}

return {
    "nvim-lualine/lualine.nvim",
    requires = { "nvim-tree/nvim-web-devicons", opt = true },

    config = function()
        local theme = require("lualine.themes.tokyonight")
        theme.normal.c.bg = nil

        require("lualine").setup({
            options = {
                theme = theme,
                globalstatus = true,
                disabled_filetypes = { "NvimTree" },
            },
        })
    end,
}


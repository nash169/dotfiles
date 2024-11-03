return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("tokyonight").setup({
            -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
            style = "storm",

            -- The theme is used when the background is set to light
            light_style = "day",

            -- Enable this to disable setting the background color
            transparent = true,

            -- Configure the colors used when opening a `:terminal`
            terminal_colors = true,

            styles = {
                -- Style to be applied to different syntax groups
                -- Value is any valid attr-list value for `:help nvim_set_hl`
                comments = { italic = true },
                keywords = { italic = true },
                functions = {},
                variables = {},

                -- Background styles. Can be "dark", "transparent" or "normal"
                sidebars = "transparent", -- style for sidebars, see below
                floats = "transparent", -- style for floating window
            },

            -- Lualine options --
            lualine = {
                transparent = true, -- lualine center bar transparency
            },

            -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
            day_brightness = 0.3,

            -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead
            hide_inactive_statusline = false,
        })

        -- load the colorscheme
        vim.cmd([[colorscheme tokyonight]])
    end,
}

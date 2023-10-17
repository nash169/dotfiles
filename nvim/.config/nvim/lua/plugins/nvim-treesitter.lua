return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",

    config = function()
        require("nvim-treesitter.configs").setup({
            -- A list of parser names, or "all" (the five listed parsers should always be installed)
            ensure_installed = { "c", "cpp", "python", "lua" },

            -- Automatically install missing parsers when entering buffer
            auto_install = true,

            -- List of parsers to ignore installing (or "all")
            ignore_install = { "latex" },

            highlight = {
                enable = true,

                -- list of language that will be disabled
                disable = { "latex" },
            },

            -- enable indentation
            indent = {
                enable = true,
                disable = { "cpp" },
            },
        })
    end,
}

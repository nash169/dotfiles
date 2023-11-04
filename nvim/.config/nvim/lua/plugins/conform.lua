return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                python = { "autopep8" },
                cpp = { "clang_format" },
                lua = { "stylua" },
            },

            format_on_save = {
                -- These options will be passed to conform.format()
                timeout_ms = 500,
                lsp_fallback = true,
            },

            formatters = {
                autopep8 = {
                    prepend_args = { "--line-length 150" },
                },
            },
        })

        vim.keymap.set({ "n", "v" }, "<leader>mp", function()
            require("conform").format({
                lsp_fallback = true,
                async = false,
                timeout_ms = 500,
            })
        end, { desc = "Format file or range (in visual mode)" })
    end,
}

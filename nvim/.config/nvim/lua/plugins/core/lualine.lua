return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },

	config = function()
		local opts = {
			options = {
				globalstatus = true,
				disabled_filetypes = { "NvimTree" },
				component_separators = { left = "|", right = "|" },
				section_separators = { left = "", right = "" },
			},
		}

		if vim.g.enable_theme then
			local theme = require("lualine.themes.tokyonight")
			theme.normal.c.bg = nil
			opts.options.theme = theme
		end

		require("lualine").setup(opts)
	end,
}

return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				-- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
				style = "night",
				-- Enable this to disable setting the background color
				transparent = true,
				styles = {
					-- Background styles. Can be "dark", "transparent" or "normal"
					sidebars = "transparent", -- style for sidebars, see below
					floats = "transparent", -- style for floating windows
				},
				hide_inactive_statusline = false,
			})

			-- load the colorscheme here
			vim.cmd([[colorscheme tokyonight]])
		end,
	},
}

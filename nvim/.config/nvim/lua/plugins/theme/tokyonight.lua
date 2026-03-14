return { -- You can easily change to a different colorscheme.
	-- Change the name of the colorscheme plugin below, and then
	-- change the command in the config to whatever the name of that colorscheme is.
	--
	-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
	"folke/tokyonight.nvim",
	priority = 1000, -- Make sure to load this before all the other start plugins.
	config = function()
		require("tokyonight").setup({
			-- -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
			-- style = "storm",

			-- -- The theme is used when the background is set to light
			-- light_style = "day",

			-- Enable this to disable setting the background color
			transparent = true,

			-- -- Configure the colors used when opening a `:terminal`
			-- terminal_colors = true,

			styles = {
				-- comments = { italic = true },
				-- keywords = { italic = true },
				-- functions = {},
				-- variables = {},
				sidebars = "transparent",
				floats = "transparent",
			},

			-- -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
			-- day_brightness = 0.3,

			-- -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead
			-- hide_inactive_statusline = false,
		})
	end,
	init = function()
		-- Load the colorscheme here.
		-- Like many other themes, this one has different styles, and you could load
		-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
		vim.cmd.colorscheme("tokyonight-storm")

		-- You can configure highlights by doing something like:
		vim.cmd.hi("Comment gui=none")
	end,
}

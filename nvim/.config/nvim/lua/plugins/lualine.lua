return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count
		local theme = require("lualine.themes.tokyonight")
		theme.normal.c.bg = nil

		-- configure lualine with modified theme
		require("lualine").setup({
			options = {
				theme = theme,
				globalstatus = true,
				disabled_filetypes = { "NvimTree" },
			},
			sections = {
				lualine_x = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						-- color = { fg = "#ff9e64" },
					},
					{ "encoding" },
					{ "fileformat" },
					{ "filetype" },
				},
			},
		})
	end,
}

return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	opts = { -- require("bufferline").setup(opts)
		options = {
			offsets = {
				{
					filetype = "NvimTree",
					text_align = "center",
					separator = true,
				},
			},
			show_close_icon = false,
			show_buffer_close_icons = false,
		},
	},
}

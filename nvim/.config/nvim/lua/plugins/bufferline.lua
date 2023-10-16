return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	opts = {
		options = {
			offsets = {
				{
					filetype = "NvimTree",
					-- text = "File Explorer",
					text_align = "center",
					separator = true,
				},
			},
		},
	},
}

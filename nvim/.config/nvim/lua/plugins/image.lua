return {
	"3rd/image.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("image").setup({
			backend = "ueberzug", -- auto-detects ueberzugpp
		})
	end,
}

return {
	"lervag/vimtex",
	config = function()
		-- -- This is necessary for VimTeX to load properly. The "indent" is optional.
		-- -- Note that most plugin managers will do this automatically.
		-- filetype plugin indent on
		--
		-- -- This enables Vim's and neovim's syntax-related features. Without this, some
		-- -- VimTeX features will not work (see ":help vimtex-requirements" for more info).
		-- syntax enable

		-- Viewer options: One may configure the viewer either by specifying a built-in viewer method:
		if vim.loop.os_uname().sysname == "Darwin" then
			vim.g.vimtex_view_method = "general"
		else
			vim.g.vimtex_view_method = "zathura"
		end

		vim.g.vimtex_compiler_latexmk = {
			options = {
				"-verbose",
				"-file-line-error",
				"-synctex=1",
				"-interaction=nonstopmode",
				"-shell-escape",
			},
		}
		-- disable autu open compiler log if there are only warnings
		vim.g.vimtex_quickfix_open_on_warning = 0

		-- -- Or with a generic interface:
		-- let g:vimtex_view_general_viewer = 'okular'
		-- let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
		--
		-- -- VimTeX uses latexmk as the default compiler backend. If you use it, which is
		-- -- strongly recommended, you probably don't need to configure anything. If you
		-- -- want another compiler backend, you can change it as follows. The list of
		-- -- supported backends and further explanation is provided in the documentation,
		-- -- see ":help vimtex-compiler".
		-- let g:vimtex_compiler_method = 'latexrun'
		--
		-- -- Most VimTeX mappings rely on localleader and this can be changed with the
		-- -- following line. The default is usually fine and is the symbol "\".
		-- let maplocalleader = ","
	end,
}

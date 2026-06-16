return { -- Highlight, edit, and navigate code
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	branch = "main",
	-- [[ Configure Treesitter ]] See `:help nvim-treesitter-intro`
	config = function()
		-- ensure basic parser are installed
		local parsers = {
			"bash",
			"python",
			"cpp",
			"c",
			"diff",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"query",
			"vim",
			"vimdoc",
		}
		require("nvim-treesitter").install(parsers)

		---@param buf integer
		---@param language string
		local function treesitter_try_attach(buf, language)
			-- check if parser exists and load it
			if not vim.treesitter.language.add(language) then
				return
			end
			-- enables syntax highlighting and other treesitter features
			vim.treesitter.start(buf, language)

			-- enables treesitter based folds
			-- for more info on folds see `:help folds`
			-- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
			-- vim.wo.foldmethod = 'expr'

			-- check if treesitter indentation is available for this language, and if so enable it
			-- in case there is no indent query, the indentexpr will fallback to the vim's built in one
			local has_indent_query = vim.treesitter.query.get(language, "indents") ~= nil

			-- enables treesitter based indentation
			if has_indent_query then
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end
		end

		local available_parsers = require("nvim-treesitter").get_available()
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local buf, filetype = args.buf, args.match

				local language = vim.treesitter.language.get_lang(filetype)
				if not language then
					return
				end

				local installed_parsers = require("nvim-treesitter").get_installed("parsers")

				if vim.tbl_contains(installed_parsers, language) then
					-- enable the parser if it is installed
					treesitter_try_attach(buf, language)
				end
			end,
		})
	end,
}

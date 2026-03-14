-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

return {
	"nvim-telescope/telescope.nvim",
	enabled = true,
	event = "VimEnter",
	dependencies = {
		"nvim-lua/plenary.nvim",

		-- ADDED: image.nvim so it's available when telescope config runs
		{ "3rd/image.nvim" },

		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	config = function()
		local actions = require("telescope.actions")

		-- ADDED: image preview hook
		local image = require("image")
		local preview_images = {}

		require("telescope").setup({
			defaults = {
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},

				preview = {
					mime_hook = function(filepath, bufnr, opts)
						local ext = vim.fn.fnamemodify(filepath, ":e"):lower()
						if not vim.tbl_contains({ "png", "jpg", "jpeg", "webp", "gif" }, ext) then
							return false
						end

						local winid = opts.winid

						-- clear previous image in this preview window
						if preview_images[winid] then
							pcall(function()
								preview_images[winid]:clear()
							end)
							preview_images[winid] = nil
						end

						-- clear buffer text
						pcall(vim.api.nvim_buf_set_lines, bufnr, 0, -1, false, {})

						local img = image.from_file(filepath, {
							window = winid,
							buffer = bufnr,
							with_virtual_padding = true,
						})
						preview_images[winid] = img

						vim.schedule(function()
							pcall(function()
								img:render()
							end)
						end)

						return true
					end,
				},
			},

			pickers = {
				find_files = { hidden = true },
				grep_string = { additional_args = { "--hidden" } },
				live_grep = { additional_args = { "--hidden" } },
			},

			extensions = {
				["ui-select"] = { require("telescope.themes").get_dropdown() },
			},
		})

		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
		vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
		vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
		vim.keymap.set({ "n", "v" }, "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
		vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
		vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
		vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
		vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
		vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "[S]earch [C]ommands" })
		vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

		-- This runs on LSP attach per buffer (see main LSP attach function in 'neovim/nvim-lspconfig' config for more info,
		-- it is better explained there). This allows easily switching between pickers if you prefer using something else!
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("telescope-lsp-attach", { clear = true }),
			callback = function(event)
				local buf = event.buf

				vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = buf, desc = "[G]oto [R]eferences" })
				vim.keymap.set(
					"n",
					"gi",
					builtin.lsp_implementations,
					{ buffer = buf, desc = "[G]oto [I]mplementation" }
				)
				-- To jump back, press <C-t>.
				vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = buf, desc = "[G]oto [D]efinition" })
				vim.keymap.set(
					"n",
					"gO",
					builtin.lsp_document_symbols,
					{ buffer = buf, desc = "Open Document Symbols" }
				)
				vim.keymap.set(
					"n",
					"gW",
					builtin.lsp_dynamic_workspace_symbols,
					{ buffer = buf, desc = "Open Workspace Symbols" }
				)
				vim.keymap.set(
					"n",
					"gt",
					builtin.lsp_type_definitions,
					{ buffer = buf, desc = "[G]oto [T]ype Definition" }
				)
			end,
		})

		-- Override default behavior and theme when searching
		vim.keymap.set("n", "<leader>/", function()
			-- You can pass additional configuration to Telescope to change the theme, layout, etc.
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, { desc = "[/] Fuzzily search in current buffer" })

		-- It's also possible to pass additional configuration options.
		--  See `:help telescope.builtin.live_grep()` for information about particular keys
		vim.keymap.set("n", "<leader>s/", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "[S]earch [/] in Open Files" })

		-- Shortcut for searching your Neovim configuration files
		vim.keymap.set("n", "<leader>sn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "[S]earch [N]eovim files" })
	end,
}

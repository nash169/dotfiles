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
				terminal_colors = true,
				styles = {
					-- Background styles. Can be "dark", "transparent" or "normal"
					sidebars = "transparent", -- style for sidebars, see below
					floats = "transparent", -- style for floating windows
				},

				-- Lualine options --
				lualine = {
					transparent = true, -- lualine center bar transparency
				},

				hide_inactive_statusline = false,
			})

			-- load the colorscheme here
			vim.cmd([[colorscheme tokyonight]])
		end,
	},
}

-- return {
-- 	{
-- 		"navarasu/onedark.nvim",
-- 		lazy = false,
-- 		priority = 1000,
-- 		config = function()
--       -- Lua
--       require('onedark').setup  {
--         -- Main options --
--         style = 'dark', -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
--         transparent = true,  -- Show/hide background
--         term_colors = true, -- Change terminal color as per the selected theme style
--         ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
--         cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu
--
--         -- toggle theme style ---
--         toggle_style_key = nil, -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
--         toggle_style_list = {'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'}, -- List of styles to toggle between
--
--         -- Change code style ---
--         -- Options are italic, bold, underline, none
--         -- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
--         code_style = {
--           comments = 'italic',
--           keywords = 'none',
--           functions = 'none',
--           strings = 'none',
--           variables = 'none'
--         },
--
--         -- Lualine options --
--         lualine = {
--           transparent = true, -- lualine center bar transparency
--         },
--
--         -- Custom Highlights --
--         colors = {}, -- Override default colors
--         highlights = {}, -- Override highlight groups
--
--         -- Plugins Config --
--         diagnostics = {
--           darker = true, -- darker colors for diagnostic
--           undercurl = true,   -- use undercurl instead of underline for diagnostics
--           background = true,    -- use background color for virtual text
--         },
--       }
--
--       -- require('onedark').load()
--
-- 			-- load the colorscheme here
-- 			-- vim.cmd([[colorscheme tokyonight]])
-- 		end,
-- 	},
-- }

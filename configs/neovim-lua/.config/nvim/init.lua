-- Load options object
require('options')

-- Load generic settings
require('settings')
require('nv-gitblame')
require('nv-matchup')
require('plugins')
require('nv-utils')
require('nv-autocommands')
require('keymappings')
require('nv-nvimtree') -- This plugin must be required somewhere before colorscheme.  Placing it after will break navigation keymappings
require('colorscheme') -- This plugin must be required somewhere after nvimtree. Placing it before will break navigation keymappings
require('nv-galaxyline')
require('nv-comment')
require('nv-gitblame')
require('nv-compe')
require('nv-barbar')
require('nv-dashboard')
require('nv-telescope')
require('nv-gitsigns')
require('nv-treesitter')
require('nv-autopairs')
require('nv-rnvimr')
require('nv-which-key')
require('nv-lsp-rooter')
require('nv-zen')

-- extras
if O.extras then
    require('nv-numb')
    require('nv-dial')
    require('nv-hop')
    require('nv-colorizer')
    require('nv-symbols-outline')
end



-- -- TODO is there a way to do this without vimscript
-- vim.cmd('source '..CONFIG_PATH..'/vimscript/functions.vim')

-- LSP
require('lsp')
require('lsp.angular-ls')
require('lsp.bash-ls')
require('lsp.clangd')
require('lsp.cmake-ls')
require('lsp.css-ls')
require('lsp.dart-ls')
require('lsp.docker-ls')
require('lsp.efm-general-ls')
require('lsp.elm-ls')
require('lsp.emmet-ls')
require('lsp.graphql-ls')
require('lsp.go-ls')
require('lsp.html-ls')
require('lsp.json-ls')
require('lsp.js-ts-ls')
require('lsp.kotlin-ls')
require('lsp.latex-ls')
require('lsp.lua-ls')
require('lsp.php-ls')
require('lsp.python-ls')
require('lsp.ruby-ls')
require('lsp.rust-ls')
require('lsp.svelte-ls')
require('lsp.terraform-ls')
-- require('lsp.tailwindcss-ls')
require('lsp.vim-ls')
require('lsp.vue-ls')
require('lsp.yaml-ls')
require('lsp.elixir-ls')

" Let clangd fully control code completion
let g:ycm_clangd_uses_ycmd_caching = 0
" Use installed clangd, not YCM-bundled clangd which doesn't get updates.
let g:ycm_clangd_binary_path = exepath("clangd")
" Configuration file
let g:ycm_global_ycm_extra_conf = '~/.config/nvim/.ycm_extra_conf.py'
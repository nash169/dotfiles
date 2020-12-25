"    ____      _ __        _
"   /  _/___  (_) /__   __(_)___ ___
"   / // __ \/ / __/ | / / / __ `__ \
" _/ // / / / / /__| |/ / / / / / / /
"/___/_/ /_/_/\__(_)___/_/_/ /_/ /_/


" Plugins
source $HOME/.config/nvim/plugins.vim

" Basic Settings
source $HOME/.config/nvim/settings.vim
source $HOME/.config/nvim/mappings.vim

" Intellisense
source $HOME/.config/nvim/plug-config/coc.vim

" Themes
source $HOME/.config/nvim/plug-config/onedark.vim
source $HOME/.config/nvim/plug-config/airline.vim

" Ranger
source $HOME/.config/nvim/plug-config/rnvimr.vim

" Fzf
source $HOME/.config/nvim/plug-config/fzf.vim

" Colorizer
luafile $HOME/.config/nvim/plug-config/plug-colorizer.lua
source $HOME/.config/nvim/plug-config/rainbow.vim

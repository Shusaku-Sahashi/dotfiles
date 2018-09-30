if g:dein#_cache_version !=# 100 || g:dein#_init_runtimepath !=# '/Users/shusaku/.vim/dunbles/repos/github.com/Shougo/dein.vim/,/Users/shusaku/.vim,/usr/local/share/vim/vimfiles,/usr/local/share/vim/vim81,/usr/local/share/vim/vimfiles/after,/Users/shusaku/.vim/after' | throw 'Cache loading error' | endif
let [plugins, ftplugin] = dein#load_cache_raw(['/Users/shusaku/.vimrc', '/Users/shusaku/.vim/config/init/dein.toml', '/Users/shusaku/.vim/config/init/dein_lazy.toml'])
if empty(plugins) | throw 'Cache loading error' | endif
let g:dein#_plugins = plugins
let g:dein#_ftplugin = ftplugin
let g:dein#_base_path = '/Users/shusaku/.vim/dunbles'
let g:dein#_runtime_path = '/Users/shusaku/.vim/dunbles/.cache/.vimrc/.dein'
let g:dein#_cache_path = '/Users/shusaku/.vim/dunbles/.cache/.vimrc'
let &runtimepath = '/Users/shusaku/.vim/dunbles/repos/github.com/Shougo/dein.vim/,/Users/shusaku/.vim,/usr/local/share/vim/vimfiles,/Users/shusaku/.vim/dunbles/.cache/.vimrc/.dein,/usr/local/share/vim/vim81,/Users/shusaku/.vim/dunbles/.cache/.vimrc/.dein/after,/usr/local/share/vim/vimfiles/after,/Users/shusaku/.vim/after'

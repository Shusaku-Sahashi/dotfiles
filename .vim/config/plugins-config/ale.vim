" シンボルカラムを表示したままにする。
let g:ale_sign_column_always = 1
let g:ale_completion_enabled = 1

" エラー間をキー操作で移動可能にする。
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" ファイル保存時のみチェックするようにする。
"let g:ale_lint_on_save = 1
"let g:ale_lint_on_text_changed = 0

" ファイルオープン時にチェックしない。
"let g:ale_lint_on_enter = 0

" エラーの確認のためにリストを表示
"let g:ale_open_list = 1
"let g:ale_keep_lint_window_open = 1


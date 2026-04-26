" ~/.vimrc - полная версия с плагинами и настройками для Python

" --- Префикс для пользовательских горячих клавиш будет пробел ---
let mapleader = " "

" === НАЧАЛО СЕКЦИИ VIM-PLUG ===
call plug#begin('~/.vim/plugged')

" Плагины для Python
Plug 'vim-python/python-syntax'     " Улучшенная подсветка Python
Plug 'dense-analysis/ale'           " Линтер (flake8, pylint)
Plug 'jiangmiao/auto-pairs'         " Умные скобки

call plug#end()
" === КОНЕЦ СЕКЦИИ VIM-PLUG ===

" === Базовые настройки ===
set nocompatible
filetype plugin indent on
syntax on
set number
set relativenumber
set showmatch
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set softtabstop=4
set backspace=indent,eol,start

" === Поиск ===
set hlsearch
set incsearch
set ignorecase
set smartcase

" === Визуальные настройки ===
set cursorline
set showcmd
set wildmenu
set wildignore=*.pyc,*.pyo,*.egg-info,__pycache__
set laststatus=2

" === Кодировка ===
set encoding=utf-8
set fileencoding=utf-8

" === Настройки для Python ===
au BufNewFile,BufRead *.py set textwidth=79
au BufNewFile,BufRead *.py set colorcolumn=79
au BufNewFile,BufRead *.py set formatoptions+=o

" === НАСТРОЙКИ ALE (тихий режим + popup по хоткею) ===
let g:ale_linters = {'python': ['flake8', 'pylint']}
let g:ale_fixers = {'python': []}
let g:ale_python_flake8_options = '--max-line-length=79'
let g:ale_python_pylint_options = '--max-line-length=79'

" --- Полностью убираем навязчивость ---
let g:ale_sign_column_always = 0
let g:ale_virtualtext_cursor = 0
let g:ale_echo_cursor = 0
let g:ale_echo_msg_format = '[%linter%] %s'

" --- Линтинг только когда ты хочешь ---
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1

" --- Popup окно с ошибкой ---
let g:ale_floating_preview = 1

" --- Список ошибок не лезет сам ---
let g:ale_open_list = 0
let g:ale_keep_list_window_open = 0

" --- Отключаем мусорные директории ---
let g:ale_pattern_options = {
\   '\.venv/': {'ale_enabled': 0},
\   'venv/': {'ale_enabled': 0},
\   '\.cache/': {'ale_enabled': 0},
\   '__pycache__/': {'ale_enabled': 0},
\}

" --- Убираем залипание popup от ALE ---
let g:ale_close_preview_on_insert = 1

" Улучшенная подсветка Python
let g:python_highlight_all = 1
let g:python_highlight_string_format = 1
let g:python_highlight_builtins = 1

" === Горячие клавиши для отладки Python ===
" F5 - запуск текущего Python файла
nnoremap <F5> :w<CR>:!clear && python3 %<CR>

" F6 - запуск с pdb (отладчик)
nnoremap <F6> :w<CR>:!clear && python3 -m pdb %<CR>

" F7 - вставить pdb.set_trace() в текущую позицию
nnoremap <F7> oimport pdb; pdb.set_trace()<Esc>

" F8 - показать подсказку для pdb
nnoremap <F8> :!echo "Use 'c' to continue, 'n' for next, 'p var' to print"<CR>

" Ctrl+P - быстрый запуск без очистки
nnoremap <C-p> :w<CR>:!python3 %<CR>

" === ALE HOTKEYS (удобная схема) ===
" Показать ошибку под курсором (главная клавиша)
nnoremap <silent> K :ALEDetail<CR>

" Следующая / предыдущая ошибка
nnoremap <silent> ]e :ALENext<CR>
nnoremap <silent> [e :ALEPrevious<CR>

" Открыть список ошибок (как Problems в IDE)
nnoremap <leader>e :ALEToggle<CR>

" Принудительно запустить линтер
nnoremap <leader>r :ALELint<CR>

" === Статус-строка с информацией о Python ===
set statusline=%F%m%r%h%w\ [Python]\ [%Y]\ [%l/%L,\ %c]

" === Автоматическое добавление shebang ===
function! AddPythonShebang()
    if getline(1) !~ "^#!"
        call append(0, "#!/usr/bin/env python3")
        call append(1, "# -*- coding: utf-8 -*-")
        call append(2, "")
    endif
endfunction
au BufNewFile *.py call AddPythonShebang()

" === Подсветка лишних пробелов (только визуально, без сообщений) ===
highlight ExtraWhitespace ctermbg=darkred guibg=darkred
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/

" === АВТОДОПОЛНЕНИЕ TAB ===
function! TabCompletion()
    if col('.') > 1 && getline('.')[col('.')-2] =~ '\a'
        return "\<C-P>"
    else
        return "\<Tab>"
    endif
endfunction
inoremap <Tab> <C-R>=TabCompletion()<CR>

set complete=.,w,b,u,t,i

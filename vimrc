" ~/.vimrc - полная версия с плагинами и настройками для Python

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

" === Настройки плагинов ===
" Настройки ALE (линтер)
let g:ale_linters = {'python': ['flake8', 'pylint']}
let g:ale_fixers = {'python': []}
let g:ale_python_flake8_options = '--max-line-length=79'
let g:ale_python_pylint_options = '--max-line-length=79'

" === ИГНОРИРОВАНИЕ СИСТЕМНЫХ ПАПОК ДЛЯ ALE ===
let g:ale_pattern_options = {
\   '\.venv/': {'ale_enabled': 0},
\   'venv/': {'ale_enabled': 0},
\   '\.cache/': {'ale_enabled': 0},
\   '__pycache__/': {'ale_enabled': 0},
\}

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

" === Подсветка лишних пробелов ===
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/

" === АВТОДОПОЛНЕНИЕ TAB ===
" Включаем автодополнение по Tab
function! TabCompletion()
    if col('.') > 1 && getline('.')[col('.')-2] =~ '\a'
        return "\<C-P>"
    else
        return "\<Tab>"
    endif
endfunction
inoremap <Tab> <C-R>=TabCompletion()<CR>

" Включаем словарь из текущего файла
set complete=.,w,b,u,t,i
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/

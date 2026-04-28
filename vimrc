" ~/.vimrc - полная версия с плагинами и настройками для Python

" --- Префикс для пользовательских горячих клавиш будет пробел ---
let mapleader = " "

" === НАЧАЛО СЕКЦИИ VIM-PLUG ===
call plug#begin('~/.vim/plugged')

" Плагины для Python
Plug 'vim-python/python-syntax'                 " Улучшенная подсветка Python
Plug 'jiangmiao/auto-pairs'                     " Умные скобки
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Completion-движок

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
set updatetime=300

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
set signcolumn=yes

" === Кодировка ===
set encoding=utf-8
set fileencoding=utf-8

" === Настройки для Python ===
au BufNewFile,BufRead *.py set textwidth=79
au BufNewFile,BufRead *.py set colorcolumn=79
au BufNewFile,BufRead *.py set formatoptions+=o

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

" === Подсветка лишних пробелов (только визуально, без сообщений) ===
highlight ExtraWhitespace ctermbg=darkred guibg=darkred
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/

" === coc.nvim автодополнение ===
inoremap <silent><expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
inoremap <silent><expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

" Ctrl+Space — вручную вызвать автодополнение
inoremap <silent><expr> <C-Space> coc#refresh()

" === Цвета для popup-меню coc.nvim ===
highlight Pmenu guibg=black ctermbg=0 guifg=green ctermfg=2
highlight PmenuSel guibg=green ctermbg=2 guifg=black ctermfg=0
highlight PmenuSbar guibg=gray ctermbg=8
highlight PmenuThumb guibg=white ctermbg=15

" === coc.nvim: навигация и диагностика ===
" Документация (hover)
nnoremap <silent> K :call CocActionAsync('doHover')<CR>

" Перейти к определению
nnoremap gd <Plug>(coc-definition)

" Следующая / предыдущая ошибка
nnoremap ]e <Plug>(coc-diagnostic-next)
nnoremap [e <Plug>(coc-diagnostic-prev)

" Список ошибок
nnoremap <leader>e :CocDiagnostics<CR>

" Форматирование
nnoremap <leader>f :call CocAction('format')<CR>

" форматирование по сохранению
autocmd BufWritePre *.py :call CocAction('format')

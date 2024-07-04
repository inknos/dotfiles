" o--o--o--o--o--o--o--o--o--o--o--o--o--o--o--o
"
"                 inknos' Vimrc
" :begin
" o--o--o--o--o--o--o--o--o--o--o--o--o--o--o--o



" :--:--:--:--:--:--:--:--:--:--:--:--:--:--:--:
"
"                   Plugins
" :begin
" :--:--:--:--:--:--:--:--:--:--:--:--:--:--:--:
"
" https://github.com/junegunn/vim-plug

" ### Specify a directory for plugins
"
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'

call plug#begin('~/.vim/plugged')

" git markers on side
Plug 'airblade/vim-gitgutter'

" Status bar
Plug 'vim-airline/vim-airline'

" YouCompleteMe
Plug 'ycm-core/YouCompleteMe'

" Whitespace check
Plug 'ntpeters/vim-better-whitespace'

" File tree on side
Plug 'scrooloose/nerdtree'

" Catppuccin theme
Plug 'catppuccin/vim', { 'as': 'catppuccin' }

" LaTeX for Vim
" Plug 'lervag/vimtex'

" Python linter
Plug 'nvie/vim-flake8'

" Clang-Format
Plug 'rhysd/vim-clang-format'

" Ack Vim
" search recursively in directories
Plug 'mileszs/ack.vim'

" FZF
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Copilot
Plug 'github/copilot.vim'

" Ale
Plug 'dense-analysis/ale'

" Vimspector
Plug 'puremourning/vimspector'

" End of Plug
" Initialize plugin system
call plug#end()

" Plugins :end
" :--:--:--:--:--:--:--:--:--:--:--:--:--:--:--:

colorscheme catppuccin_mocha
set termguicolors

" :--:--:--:--:--:--:--:--:--:--:--:--:--:--:--:
"
"               Per Plugin Config
"
" :--:--:--:--:--:--:--:--:--:--:--:--:--:--:--:
" This configuration is not supposed to work
" everywhere but only with pligins installed


" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~
"
"                Copilot
" :begin
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~

" Disable Copilot for files larger than 100kb
autocmd BufReadPre *
    \ let f=getfsize(expand("<afile>"))
    \ | if f > 100000 || f == -2
    \ | let b:copilot_enabled = v:false
    \ | endif

" Copilot :end

" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~
"
"                    Vimtex
" :begin
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~

let g:vimtex_view_method = 'zathura'

" VimTex : end
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~

" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~
"
"                    FZF
" :begin
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~
"
" https://github.com/junegunn/fzf/blob/master/README-VIM.md
" https://github.com/junegunn/fzf/wiki/Examples-(vim)
let $FZF_DEFAULT_OPTS='--ansi --phony'
let g:fzf_colors = {
    \ 'fg':      ['fg', 'Normal'],
    \ 'bg':      ['bg', 'Normal'],
    \ 'hl':      ['fg', 'Comment'],
    \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
    \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
    \ 'hl+':     ['fg', 'Statement'],
    \ 'info':    ['fg', 'PreProc'],
    \ 'border':  ['fg', 'Ignore'],
    \ 'prompt':  ['fg', 'Conditional'],
    \ 'pointer': ['fg', 'Exception'],
    \ 'marker':  ['fg', 'Keyword'],
    \ 'spinner': ['fg', 'Label'],
    \ 'header':  ['fg', 'Comment'] }
function! s:buflist()
    " Return listed buffers that have a name
    let listed = filter(range(1, bufnr('$')), 'buflisted(v:val)')
    let named = map(listed, 'bufname(v:val)')
    let named = filter(named, '!empty(v:val)')
    return named
endfunction
command! FZFBuffers
    \ call fzf#run(fzf#wrap({
    \   'source':  reverse(<sid>buflist()),
    \   'options': '+m --prompt "buffer> "',
    \ }))
command! FZFTags
    \ if !empty(tagfiles()) | call fzf#run(fzf#wrap({
    \   'source':  "sed '/^\\!/d;s/\t.*//' " . join(tagfiles()) . ' | uniq',
    \   'sink':    'tag',
    \   'options': '+m --prompt "tag> "',
    \ })) | else | echoerr 'No tags found' | endif
nmap <leader><leader> :RG<CR>
nmap <leader>b :FZFBuffers<CR>
nmap <leader>f :FZF<CR>
nmap <leader>t :FZFTags<CR>

" FZF : end
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~

" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~
"
"                   ack.vim
" :begin
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~

cnoreabbrev Ack Ack!
nnoremap <Leader>a :Ack!<Space>

" ack.vim :end
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~

"
"                 Clang Format
" :begin
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~

let g:clang_format#detect_style_file = 1

" Clang Format :end
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~


" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~
"
"               Vim Gutter
" :begin
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~
" Requires 'airblade/vim-gitgutter'

" Disable GitGutter
" let g:gitgutter_enabled = 0

" Color style
hi GitGutterAdd    cterm=bold ctermfg=darkgreen
hi GitGutterChange cterm=bold ctermfg=darkyellow
hi GitGutterDelete cterm=bold ctermfg=darkred

hi GitGutterAdd    gui=bold guifg=darkgreen
hi GitGutterChange gui=bold guifg=darkyellow
hi GitGutterDelete gui=bold guifg=darkred

" Vim Gitgutter :end
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~


" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~
"
"               Vim Airline
" :begin
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~
" Requires 'vim-airline/vim-airline'
" Requires 'vim-airline/vim-airline-themes'

let g:airline_theme = 'catppuccin_mocha'
set noshowmode

" Vim Airline :end
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~


" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~
"
"            Catppuccin Theme
" :begin
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~
" Catppuccin Theme :end
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~


" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~
"
"            Vim Better Whitespace
" :begin
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~
" Requires 'ntpeters/vim-better-whitespace'

" Trailing spaces
let c_space_errors = 1
let python_space_errors = 1

" Vim Better Whitespace :end
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~


" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~
"
"                YouCompleteMe
" :begin
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~
" Requires 'ycm-core/YouCompleteMe'

" YCM errors
let g:ycm_error_symbol = 'E'
let g:ycm_warning_symbol = 'W'
let g:ycm_enable_diagnostic_signs = 0
let g:ycm_enable_diagnostic_highlighting = 0

" YouCompleteMe :end
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~

" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~
"
"                     Ale
" :begin
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~
let b:ale_fixers = ['black', 'ruff']
let b:ale_linters = ['pyright']

" Ale :end
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~

" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~
"
"                Vimspector
" :begin
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~
let g:vimspector_enable_mappings = 'HUMAN'
" Vimspector :end
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~

" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~
"
"             The Silver Searcher
" :begin
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~

if executable('ag')
    " Use ag over grep
    set grepprg=ag\ --nogroup\ --nocolor

    " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

    " ag is fast enough that CtrlP doesn't need to cache
    let g:ctrlp_use_caching = 0
endif

" The Silver Searcher :end
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~


" Per Plugin Config :end
" :--:--:--:--:--:--:--:--:--:--:--:--:--:--:--:



" :--:--:--:--:--:--:--:--:--:--:--:--:--:--:--:
"
"         General Config aka Must Have
" :begin
" :--:--:--:--:--:--:--:--:--:--:--:--:--:--:--:

" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~
"
"                 Line Number
" :begin
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~

" Line number relative
set number relativenumber
highlight LineNr ctermfg=grey

" Line number absolute in insert mode
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" Line Number :end
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~


" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~
"
"           Characters and Columns
" :begin
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~

" Case sensitive when capital letter in search
set smartcase

" column 80 chars
" set colorcolumn=120
match ErrorMsg '\%>120v.\+'

" Avoid breaking middle of a word
set linebreak

" Characters and Columns :end
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~


" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~
"
"                    Tabs
" :begin
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~

" Tab default to 4 spaces
set tabstop=4       " The width of a TAB is set to 4.

" Still it is a \t. It is just that
" Vim will interpret it to be having
" a width of 4.
set shiftwidth=4    " Indents will have a width of 4
set softtabstop=4   " Sets the number of columns for a TAB
set expandtab       " Expand TABs to spaces

" Tabs :end
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~


" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~
"
"               Visual Effects
" :begin
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~

" auto close completion window
au CompleteDone * pclose

" Visual Effects :end
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~


" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~
"
"               Backup and Swap
" :begin
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~

" Swap Configuration not to mess with stuff
set backupdir=~/.cache/vim/bkp
set dir=~/.cache/vim/swp
set wildignore+=.pyc,.swp

" Backup and Swap :end
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~


" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~
"
"               Wayland Config
" :begin
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~

" Copy to clipboard under wayland
xnoremap "+y y:call system("wl-copy", @")<cr>
nnoremap "+p :let @"=substitute(system("wl-paste --no-newline"), '<C-v><C-m>', '', 'g')<cr>p
nnoremap "*p :let @"=substitute(system("wl-paste --no-newline --primary"), '<C-v><C-m>', '', 'g')<cr>p

" Wayland Config :end
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~


" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~
"
"                    Commands
" :begin
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~

" Diff all the open windows
command! Difft windo diffthis
"
" Stop diff all the open windows
command! Diffo windo diffoff

" Commands :end
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~


" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~
"
"                   Rebinds
" :begin
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~

" bind K to grep word under cursor
" nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" Rebinds :end
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~


" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~
"
"               Function Rebinds
" :begin
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~

" map <F1> :help<CR>

" Open/Close NerdTree
" Requires 'scrooloose/nerdtree'
map <F2> :NERDTreeToggle<CR>

" Run FLAKE8
autocmd FileType python map <buffer> <F3> :call flake8#Flake8()<CR>

" Save Vim State
" map <F5> :SSave<CR>

" Format buffer
map <F7> gg=G<C-o><C-o>

" Format Clang
" Requires 'rhysd/vim-clang-format'
map <F8> :ClangFormat<CR>

" Compile vimwiki
" Requires VimWiki
" map <F12> :VimwikiAll2HTML<CR>

" Function Rebinds :end
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~


" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~
"
"              Filetype Rebinds
" :begin
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~


" Filetype Rebinds :end
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~

autocmd BufEnter *.fmf :setlocal filetype=yaml
" General Config aka Must Have :end
" :--:--:--:--:--:--:--:--:--:--:--:--:--:--:--:



" inknos' Vimrc :end
" o--o--o--o--o--o--o--o--o--o--o--o--o--o--o--o

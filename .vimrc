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
Plug 'vim-airline/vim-airline-themes'

" YouCompleteMe
Plug 'ycm-core/YouCompleteMe'

" Whitespace check
Plug 'ntpeters/vim-better-whitespace'

" File tree on side
Plug 'scrooloose/nerdtree'

" Surround brachets automatically
Plug 'tpope/vim-surround'

" Vim Wiki
Plug 'vimwiki/vimwiki', { 'branch': 'dev' }

" Siver searcher and Vim-Zettel
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'michal-h21/vim-zettel'

" LaTeX for Vim
Plug 'lervag/vimtex'

" Python linter
Plug 'nvie/vim-flake8'

" Clang-Format
Plug 'rhysd/vim-clang-format'

" Ack Vim
Plug 'mileszs/ack.vim'

" Unused plugins

" Encrypt vim wiki
" Plug 'jamessan/vim-gnupg'

" git plugin
" Plug 'tpope/vim-fugitive'

" Advanced UNIX commands
" Plug 'tpope/vim-eunuch'

" Advanced terminal
" Plug 'wincent/terminus'

" Wrap comments
"Plug 'preservim/nerdcommenter'

" TaskWarrior
" Plug 'blindFS/vim-taskwarrior'

" End of Plug
" Initialize plugin system
call plug#end()

" Plugins :end
" :--:--:--:--:--:--:--:--:--:--:--:--:--:--:--:



" :--:--:--:--:--:--:--:--:--:--:--:--:--:--:--:
"
"               Per Plugin Config
"
" :--:--:--:--:--:--:--:--:--:--:--:--:--:--:--:
" This configuration is not supposed to work
" everywhere but only with pligins installed


" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~
"
"                  VimWiki
" :begin:unused
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~

" set nocompatible
" filetype plugin on
" syntax on
"
" let g:vimwiki_links_space_char = '_'
" let g:vimwiki_auto_header = 1
" let g:vimwiki_list = [{ 'path': '~/Documents/VimWiki/text',
"             \ 'template_path': '~/Documents/VimWiki/templates/',
"             \ 'auto_tag': 1,
"             \ 'auto_toc': 1,
"             \ 'template_default': 'default',
"             \ 'syntax': 'markdown', 'ext': '.md',
"             \'custom_wiki2html': 'vimwiki_markdown',
"             \ 'html_filename_parameterization': 1,
"             \ 'path_html': '~/Documents/VimWiki/html/',
"             \ 'template_ext': '.tpl'}]
" let g:vimwiki_auto_chdir = 1
" let g:vimwiki_hl_headers=1
"
" Vim-Zettel options
" let g:zettel_options = [{"front_matter" : {"tags" : ""},
"             \ "template" :  "~Documents/Vimwiki/templates/zettel.tpl"}]
" let g:zettel_format = '%Y%m%d%H%M%S'
"
" Zettel search
" inoremap [[ [[<esc>:ZettelSearch<CR>
" imap <silent> [[ [[<esc><Plug>ZettelSearchMap
"
" Zettel copy link
" nmap T <Plug>ZettelYankNameMap
"
" Create note with selected text
" xnoremap z :call zettel#vimwiki#zettel_new_selected()<CR>
" xmap z <Plug>ZettelNewSelectedMap
"
" Additional Mappings for Vimwiki
"
"       <leader>v...
"
" Check Vimwiki backlinks
" nnoremap <leader>vb :VimwikiBacklinks<CR>
"
" Check orphan Links
" nnoremap <leader>vc :VimwikiCheckLinks<CR>
"
" Text Search
" nnoremap <leader>vs :VimwikiSearch<space>
"
" Tag Search
" nnoremap <leader>vt :VimwikiSearchTags<space>
"
" Mappings for Vimwiki without v
"
" This mapping runs two Vimwiki functions that keep the Vimwiki
" tags file up-to-date and generates an index by tag of file
" links in the index.wiki file.
" nnoremap <leader>gt :VimwikiRebuildTags!<cr>:VimwikiGenerateTagLinks<cr><c-l>
"
" This one is useful when you want to know what zettels link
" to the current one. It opens a window split with a list of those files.
" nnoremap <leader>bl :VimwikiBacklinks<cr>
"
" Mappings for Zettel
"
"       <leader>z...
"
" This mapping and the even more convenient [[ insert mode mapping
" let you search for existing notes to insert as a link to the current file.
" nnoremap <leader>zl :ZettelSearch<cr>
"
" <leader>zn creates a new zettel based on the template
" we defined earlier named with a unique zettel ID.
" nnoremap <leader>zn :ZettelNew<cr><cr>:4d<cr>:w<cr>ggA
" nnoremap <leader>zn :ZettelNew<CR>

" GPG
" Encryption Vimwiki
"
" GPG wiki (does not work-ish)
" let g:GPGFilePattern = '*.\(gpg\|asc\|pgp\)\(.wiki\)\='


" VimWiki :end
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~


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

let g:airline_theme="term"
set noshowmode

" Vim Airline :end
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
" This is supposed to work everywhere
" Minimal vim config to feel home

" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~
"
"               Colors
" :begin
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~

" set bg=dark
" set termguicolors
set t_Co=16

" Highlight Mode
hi CursorLine    cterm=NONE  ctermbg=black
hi LineNR        cterm=NONE  ctermbg=none      ctermfg=blue
hi CursorLineNR  cterm=NONE  ctermbg=none      ctermfg=darkblue
hi Visual                    ctermbg=darkblue  ctermfg=grey
hi Search                    ctermbg=yellow    ctermfg=black
hi Pmenu                     ctermbg=darkgrey  ctermfg=white
hi PmenuSel                  ctermbg=black     ctermfg=grey
hi ColorColumn               ctermbg=darkgrey
hi VertSplit     cterm=NONE  ctermbg=darkgrey  ctermfg=black

hi Normal                    guifg=white       guibg=black
hi CursorLine    gui=NONE    guibg=black
hi LineNR        gui=NONE    guibg=NONE        guifg=blue
hi CursorLineNR  gui=NONE    guibg=NONE        guifg=darkblue
hi Visual        gui=none    guibg=darkblue    guifg=grey
hi Search                    guibg=yellow      guifg=black
hi Pmenu                     guibg=darkgrey    guifg=white
hi PmenuSel                  guibg=black       guifg=grey
hi ColorColumn               guibg=darkgrey
hi VertSplit     gui=NONE    guibg=darkgrey    guifg=black

" Highlight line
set cursorline

" For mutt
au BufRead /tmp/mutt-* set tw=72
au BufRead $HOME_CACHE_DIR/tmp/mutt-* set tw=72

" Colors :end
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~


" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~
"
"                 Line Number
" :begin
" ~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~

" Line number relative
set number relativenumber

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
" set colorcolumn=80
match ErrorMsg '\%>150v.\+'

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

" Flash if error
set visualbell

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


" General Config aka Must Have :end
" :--:--:--:--:--:--:--:--:--:--:--:--:--:--:--:



" inknos' Vimrc :end
" o--o--o--o--o--o--o--o--o--o--o--o--o--o--o--o

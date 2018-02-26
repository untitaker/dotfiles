" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
filetype plugin indent on
call pathogen#infect()

" Hardcode such that it works in virtualenv
let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'

" aliases
command Q q!
nmap ; :
nmap QQ :q!<enter>
nmap qq :q<enter>
vnoremap // y/<C-R>"<CR>

" set default encoding
set encoding=utf-8
if &termencoding == ""
    let &termencoding = &encoding
endif
setglobal fileencoding=utf-8

"setglobal bomb
set fileencodings=ucs-bom,utf-8,latin1

" Remember cursor position
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" Set backup dir
set backupdir=~/tmp/vim
set directory=~/tmp/vim

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
	set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
syntax enable
set hlsearch
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<,nbsp:%

" i don't edit Modula 2
au BufNewFile,BufRead *.md  set filetype=markdown

" don't create swapfiles for passwords
au BufNewFile,BufRead /dev/shm/pass.* setlocal noswapfile nobackup noundofile

" Folding
set nofoldenable
nmap <space> za

" EasyMotion
let g:EasyMotion_leader_key = '<Leader>'

" supertab
let g:SuperTabDefaultCompletionType = "context"

" Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_enable_signs = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1
noremap <f7> :w<CR>:SyntasticCheck<CR>

let g:syntastic_python_checkers = ['flake8', 'python']
let g:syntastic_javascript_checkers = ['eslint', 'jshint']
let g:syntastic_tex_checkers = []

" Better :sign interface symbols
let g:syntastic_error_symbol = 'X'
let g:syntastic_style_error_symbol = 'X'

let g:syntastic_warning_symbol = 'x'
let g:syntastic_style_warning_symbol = 'x'

" taglist
noremap <f4> :TlistToggle<CR>

" language server

set hidden

let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ }

nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>



let base16colorspace=256
set history=50  " keep 50 lines of command line history
set ruler       " show the cursor position all the time
set showcmd     " display incomplete commands
set incsearch   " do incremental searching
set number      " show line numbers
colo base16-bright " color scheme
set background=dark " Remote hosts will assume otherwise without this

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set tabstop=4 shiftwidth=4 expandtab
set smartindent

" Colorcolumns
autocmd FileType ruby,python,javascript,c,cpp,objc silent! setlocal colorcolumn=80 
" Python
autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8 foldmethod=indent
\ formatoptions+=croq softtabstop=4 smartindent
\ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
autocmd FileType tex setlocal shiftwidth=2
let python_highlight_all=1
let python_highlight_exceptions=0
let python_highlight_builtins=0

autocmd FileType pyrex setlocal expandtab shiftwidth=4 tabstop=8
\ softtabstop=4 smartindent
\ cinwords=if,elif,else,for,while,try,except,finally,def,class,with

" Java
autocmd FileType java setlocal omnifunc=javacomplete#Complete

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" Deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_completion_start_length = 2
let g:deoplete#sources = {}
let g:deoplete#sources._ = []
let g:deoplete#file#enable_buffer_path = 1
let g:deoplete#omni_patterns = {}

autocmd! BufRead,BufNewFile *.{vcf,ics} setfiletype icalendar

" bash-ish autocompletion
set wildmode=longest,list,full
set wildmenu
set clipboard=unnamedplus

" buffer switching with F2, F3
noremap <f2> :bprev<CR> 
noremap <f3> :bnext<CR>

" window switching with Ctrl + hjkl
noremap <C-H> :wincmd h<CR>
noremap <C-J> :wincmd j<CR>
noremap <C-K> :wincmd k<CR>
noremap <C-L> :wincmd l<CR>
noremap <C-X> :bw<CR>

" Automatic word-wrapping with W
noremap W gq

" modelines
set modeline
" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
  let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d :",
        \ &tabstop, &shiftwidth, &textwidth)
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" See unsaved changes diff
if !exists(":DiffOrig")
	command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis
endif

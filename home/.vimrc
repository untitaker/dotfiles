" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
filetype plugin indent on
call pathogen#infect()

" aliases
command Q q!
nmap ; :
nmap QQ :q!<enter>
nmap qq :q<enter>

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

" Folding
set foldmethod=syntax
set foldlevelstart=1
set foldnestmax=2
nmap <space> za

" EasyMotion
let g:EasyMotion_leader_key = '<Leader>'

" supertab
let g:SuperTabDefaultCompletionType = "context"

" Jedi
let g:jedi#popup_on_dot = 0  " Disable the automatic suggestions

" taglist
noremap <f4> :TlistToggle<CR>



set history=50  " keep 50 lines of command line history
set ruler       " show the cursor position all the time
set showcmd     " display incomplete commands
set incsearch   " do incremental searching
set number      " show line numbers
colo solarized " color scheme
set background=dark " Remote hosts will assume otherwise without this
se t_Co=16

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set tabstop=4 shiftwidth=4 expandtab
set smartindent

" Colorcolumns
silent! autocmd FileType ruby,python,javascript,c,cpp,objc setlocal colorcolumn=80

" Python
autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8 foldmethod=indent
\ formatoptions+=croq softtabstop=4 smartindent
\ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
let python_highlight_all=1
let python_highlight_exceptions=0
let python_highlight_builtins=0

autocmd FileType pyrex setlocal expandtab shiftwidth=4 tabstop=8
\ softtabstop=4 smartindent
\ cinwords=if,elif,else,for,while,try,except,finally,def,class,with

" bash-ish autocompletion
set wildmode=longest,list,full
set wildmenu
set clipboard=unnamedplus

" buffer switching with F2, F3
noremap <f2> :bprev<CR> 
noremap <f3> :bnext<CR>
noremap <M-X> :bw<CR>

" window switching with Ctrl + hjkl
noremap <M-H> :wincmd h<CR>
noremap <M-J> :wincmd j<CR>
noremap <M-K> :wincmd k<CR>
noremap <M-L> :wincmd l<CR>

" Automatic word-wrapping with W
map W gq

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

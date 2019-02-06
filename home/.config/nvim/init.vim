" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
set hidden

" Install FZF
set rtp+=/usr/local/opt/fzf

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.config/nvim/plugged')

Plug('git://github.com/vim-scripts/Jinja.git')
Plug('git://github.com/scrooloose/nerdcommenter.git')
Plug('git://github.com/ervandew/supertab.git')
Plug('git://github.com/tpope/vim-fugitive.git')
Plug('git://github.com/mitsuhiko/vim-python-combined.git')
Plug('git://github.com/hynek/vim-python-pep8-indent.git')
Plug('https://github.com/chriskempson/base16-vim')
Plug('https://github.com/vim-scripts/icalendar.vim')
Plug('https://github.com/rust-lang/rust.vim')
Plug('https://github.com/pangloss/vim-javascript')
Plug('https://github.com/mustache/vim-mustache-handlebars')
Plug('https://github.com/kelwin/vim-smali')
Plug('https://github.com/Shougo/deoplete.nvim')

Plug 'https://github.com/autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" Initialize plugin system
call plug#end()


" Hardcode such that it works in virtualenv
if has("mac")
    let g:python_host_prog = '/usr/local/bin/python2'
    let g:python3_host_prog = '/usr/local/bin/python3'
else
    let g:python_host_prog = '/usr/bin/python2'
    let g:python3_host_prog = '/usr/bin/python3'
endif

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
au Syntax * syntax sync fromstart
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

" taglist
noremap <f4> :TlistToggle<CR>

set termguicolors
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
autocmd FileType ruby,python,javascript,c,cpp,objc silent! setlocal colorcolumn=80 shiftwidth=2
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


" language server
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ 'python': ['pyls'],
    \ 'ruby': ['language_server-ruby'],
    \ }

nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F6> :call LanguageClient#textDocument_rename()<CR>
nnoremap <silent> <C-S> :call LanguageClient#textDocument_documentSymbol()<CR>
nnoremap <silent> <C-F> :call LanguageClient#textDocument_codeAction()<CR>
set signcolumn=yes

" Java
autocmd FileType java setlocal omnifunc=javacomplete#Complete

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

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

" delete parens
noremap d( ma%x`ax

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

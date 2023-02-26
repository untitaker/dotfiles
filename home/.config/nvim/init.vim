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

Plug 'https://github.com/scrooloose/nerdcommenter.git'
Plug 'https://github.com/tpope/vim-fugitive.git'
Plug 'https://github.com/tpope/vim-rhubarb.git'
Plug 'https://github.com/chriskempson/base16-vim'
Plug 'https://github.com/vim-scripts/icalendar.vim'
Plug 'https://github.com/kelwin/vim-smali'
Plug 'https://github.com/mitsuhiko/vim-python-combined'
Plug 'https://github.com/rust-lang/rust.vim'
Plug 'https://github.com/ziglang/zig.vim'
Plug 'https://github.com/terryma/vim-multiple-cursors'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'ap/vim-css-color'
Plug 'jeetsukumaran/vim-indentwise'
Plug 'leafOfTree/vim-svelte-plugin'

"Plug 'https://github.com/autozimu/LanguageClient-neovim', {
    "\ 'branch': 'next',
    "\ 'do': 'bash install.sh',
    "\ }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'https://github.com/fannheyward/coc-rust-analyzer', {'do': 'volta run --node 14.17.0 --yarn 1.22.5 yarn install --frozen-lockfile && sh ~/.config/nvim/install-rust-analyzer.sh'}
Plug 'https://github.com/fannheyward/coc-pyright', {'do': 'volta run --node 14.17.0 --yarn 1.22.5 yarn install --frozen-lockfile'}
Plug 'https://github.com/neoclide/coc-tsserver', {'do': 'volta run --node 14.17.0 --yarn 1.22.5 yarn install --frozen-lockfile'}
Plug 'https://github.com/coc-extensions/coc-svelte', {'do': 'volta run --node 14.17.0 --yarn 1.22.5 yarn install --frozen-lockfile'}

" Initialize plugin system
call plug#end()

" volta run --node 14.17.0 node -p 'process.argv[0]'
let g:coc_node_path = '$HOME/.volta/tools/image/node/14.17.0/bin/node'
let b:coc_root_patterns = ['.git']
let g:coc_config_home = '~/.config/nvim/'

" i don't control which version ubuntu comes with, are you serious?
let g:coc_disable_startup_warning = 1

" Hardcode such that it works in virtualenv
if has("mac")
    let g:python_host_prog = '/usr/local/bin/python2'
    let g:python3_host_prog = '/usr/local/bin/python3'
else
    let g:python_host_prog = '/usr/bin/python2'
    let g:python3_host_prog = '/usr/bin/python3'
endif

" aliases
nmap ; :
nmap QQ :q!<enter>
nmap qq :q<enter>
set inccommand=nosplit

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

" Less lag with esc
set ttimeoutlen=100
set autoread

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
syntax enable
au Syntax * syntax sync fromstart
set hlsearch
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<,nbsp:%

" i don't edit Modula 2
au BufNewFile,BufRead *.md set filetype=markdown linebreak
au BufNewFile,BufRead *.mdx set filetype=markdown linebreak

" Cheap way to bring some color into toml files
au BufNewFile,BufRead *.toml set filetype=cfg linebreak

" don't create swapfiles for passwords
au BufNewFile,BufRead /dev/shm/pass.* setlocal noswapfile nobackup noundofile

" Folding
set nofoldenable
nmap <space> za

" EasyMotion
let g:EasyMotion_leader_key = '<Leader>'

" Git
command -range=-1 Gblame Git blame
command -range=-1 Gbrowse GBrowse

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
autocmd FileType ruby,python,javascript,c,cpp,objc,typescript,javascriptreact,typescriptreact,tsx silent! setlocal colorcolumn=80 shiftwidth=2
" Python
autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8 foldmethod=indent
\ formatoptions+=croq softtabstop=4 smartindent
autocmd FileType tex setlocal shiftwidth=2
let python_highlight_class_vars=0
let python_highlight_operators=0
let python_highlight_exceptions=0
let python_highlight_builtins=0

autocmd FileType pyrex setlocal expandtab shiftwidth=4 tabstop=8
\ softtabstop=4 smartindent

set signcolumn=no

" https://github.com/neoclide/coc.nvim/wiki/Completion-with-sources
inoremap <expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
inoremap <expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"
inoremap <expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gre <Plug>(coc-references)
nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gf <Plug>(coc-fix-current)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>


function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

nmap <silent> grn <Plug>(coc-rename)

" Java
autocmd FileType java setlocal omnifunc=javacomplete#Complete

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

autocmd! BufRead,BufNewFile *.{vcf,ics} setfiletype icalendar
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescriptreact

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

" spacemod integration
" take current selection and pipe it to spacemod-vim
" https://vi.stackexchange.com/a/9891
vnoremap <silent> <C-R> c<c-r>=system("spacemod-vim " . bufname("%"), @")<cr><esc>u

" delete parens
nnoremap d( ma%x`ax

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

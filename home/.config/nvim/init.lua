vim.cmd([[
set nocompatible
set hidden

set rtp+=/usr/local/opt/fzf

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.config/nvim/plugged')

Plug 'https://github.com/scrooloose/nerdcommenter.git'
Plug 'https://github.com/tpope/vim-fugitive.git'
Plug 'https://github.com/tpope/vim-rhubarb.git'
Plug 'https://github.com/tpope/vim-surround.git'
Plug 'https://github.com/chriskempson/base16-vim'
Plug 'https://github.com/mitsuhiko/vim-python-combined'
Plug 'https://github.com/rust-lang/rust.vim'
Plug 'https://github.com/terryma/vim-multiple-cursors'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'ap/vim-css-color'
Plug 'jeetsukumaran/vim-indentwise'
Plug 'leafOfTree/vim-svelte-plugin'
Plug 'alaviss/nim.nvim'

" lsp
Plug 'https://github.com/neovim/nvim-lspconfig'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/nvim-cmp'

" Initialize plugin system
call plug#end()
]])

-- more lsp stuff
-- copied from https://github.com/VonHeikemen/lsp-zero.nvim

-- Reserve a space in the gutter
vim.opt.signcolumn = 'yes'

local lspconfig = require'lspconfig'

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gre', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'grn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  end,
})

-- You'll find a list of language servers here:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
-- These are example language servers. 
lspconfig.rust_analyzer.setup({
    on_attach = function(client, bufnr)
      -- disable semantic tokens, causes too janky syntax highlighting
      client.server_capabilities.semanticTokensProvider = nil
    end,
    cmd = { "wrapped-rust-analyzer" },
    settings = {
        ["rust-analyzer"] = {
            diagnostics = {
                enable = false,
            },
            checkOnSave = {
                enable = false,
            },
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true
            },
        }
    }
})

local cmp = require'cmp'

local cmpMapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        if #cmp.get_entries() == 1 then
          cmp.confirm({ select = true })
        else
          local entry = cmp.get_selected_entry()
          if entry then
            cmp.confirm()
          end
        end
      else
        fallback()
      end
    end, { "i","s" }),

    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      else
        fallback()
      end
    end, { "i","s" }),

    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      end
    end, { "i", "s" }),
})

cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
    },
    snippet = {
        expand = function(args)
        -- You need Neovim v0.10 to use vim.snippet
        vim.snippet.expand(args.body)
        end,
    },
    mapping = cmpMapping,
})



vim.cmd([[
" aliases
nmap ; :
nmap QQ :q!<enter>
nmap qq :q<enter>

colorscheme base16-bright

" Remember cursor position
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" Set backup dir
set backupdir=~/tmp/vim
set directory=~/tmp/vim

" Less lag with esc
set ttimeoutlen=100
set autoread

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
au Syntax * syntax sync fromstart
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<,nbsp:%

" i don't edit Modula 2
au BufNewFile,BufRead *.md set filetype=markdown linebreak
au BufNewFile,BufRead *.mdx set filetype=markdown linebreak

" Cheap way to bring some color into toml files
au BufNewFile,BufRead *.toml set filetype=cfg linebreak

au BufNewFile,BufRead *.go set noexpandtab

" don't create swapfiles for passwords
au BufNewFile,BufRead /dev/shm/pass.* setlocal noswapfile nobackup noundofile

" Folding
set nofoldenable
nmap <space> za

" Git
command Gblame Git blame

set ruler       " show the cursor position all the time
set showcmd     " display incomplete commands
set incsearch   " do incremental searching
set number      " show line numbers
set background=dark " Remote hosts will assume otherwise without this

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set tabstop=4 shiftwidth=4 expandtab
set smartindent

" Colorcolumns
autocmd FileType ruby,python,json,javascript,c,cpp,objc,typescript,javascriptreact,typescriptreact,tsx silent! setlocal colorcolumn=80 shiftwidth=2
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

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Java
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
]])

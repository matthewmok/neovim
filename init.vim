" general settings
set number
set smartindent
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=4
set ignorecase
set smartcase
set virtualedit=onemore
set undofile
set undolevels=1000
set undoreload=10000
set undodir=$HOME/.config/nvim/undo
set wildmode=longest,list:longest
set inccommand=nosplit
set lazyredraw
set noshowmode
set cursorline
set noerrorbells visualbell t_vb=
" disable automatic commenting
autocmd FileType * setlocal formatoptions-=cro
set formatoptions-=cro
set mouse=a
" plugins
call plug#begin($HOME . '/.config/nvim/plugged')
" junegunn
Plug 'junegunn/fzf', {
  \ 'dir': '~/.fzf',
  \ 'do': './install --all',
  \ }
Plug 'junegunn/fzf.vim'
" tpope
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
" languages
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'
Plug 'hashivim/vim-terraform'
Plug 'ekalinin/Dockerfile.vim'
Plug 'vim-scripts/groovy.vim'
Plug 'pangloss/vim-javascript'
Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'jelera/vim-javascript-syntax'
" language server
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'pappasam/coc-jedi', { 'do': 'yarn install --frozen-lockfile && yarn build', 'branch': 'main' }
" auto complete
Plug 'ncm2/ncm2'
" Plug 'ncm2/ncm2-go'
" Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'roxma/nvim-yarp', { 'do': 'pip install -r requirements.txt' }
" linting
Plug 'w0rp/ale'
" lightline
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
" utilities
Plug 'jremmen/vim-ripgrep'
Plug 'sgur/vim-editorconfig'
Plug 'ludovicchabant/vim-gutentags'
Plug 'mhinz/vim-signify'
Plug 'christoomey/vim-tmux-navigator'
" themes
Plug 'drewtempelmeyer/palenight.vim'
Plug 'sickill/vim-monokai'
Plug 'sts10/vim-pink-moon'
" finding
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary!' }
" markdown
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
call plug#end()

" configure coc extensions
call coc#add_extension(
      \ 'coc-json',
      \ 'coc-python',
      \ 'coc-yaml',
      \)

" colorscheme
set background=dark
syntax enable
colorscheme pink-moon

if (has("termguicolors"))
  set termguicolors
endif
let g:palenight_terminal_italics = 1
" python remote plugin
let g:python3_host_prog='/Users/matthewmok/miniconda/bin/python3'
let g:python_host_prog='/Users/matthewmok/miniconda/bin/python'

" auto complete
set completeopt=noinsert,menuone,noselect
set shortmess+=c
inoremap <c-c> <ESC>
inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
autocmd BufEnter * call ncm2#enable_for_buffer()

" language server
let g:LanguageClient_diagnosticsEnable = 0
let g:LanguageClient_serverCommands = {
  \ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
  \ 'javascript.jsx': ['/usr/local/bin/javascript-typescript-stdio'],
  \ 'python': ['pyls'],
  \ }
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<cr>
nnoremap <silent> K :call LanguageClient#textDocument_hover()<cr>

" ale
let g:ale_sign_column_always = 1
let g:ale_linters_explicit = 1
let g:ale_fix_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_insert_leave = 1
let g:ale_set_highlights = 0
let g:ale_sign_warning = ''
let g:ale_sign_error = ''

let g:ale_linters = {
  \ 'python': ['flake8'],
  \ 'javascript': ['eslint'],
  \ }
let g:ale_fixers = {
  \ '*': ['remove_trailing_lines', 'trim_whitespace'],
  \ 'python': ['isort', 'black'],
  \ 'javascript': ['prettier'],
  \ 'json': ['prettier'],
  \ }

" gutentags
let g:gutentags_exclude_filetypes = ['gitcommit', 'vim']

" signify
let g:signify_vcs_list = ['git']

" lightline
let g:lightline = {
  \ 'colorscheme': 'wombat',
  \ 'active': {
  \   'left': [['mode', 'paste'],
  \            ['fugitive', 'filename', 'filetype']],
  \   'right': [['lineinfo'], ['percent'],
  \             ['linter_errors', 'linter_warnings']],
  \ },
  \ 'component_function': {
  \   'mode': 'LightLineMode',
  \   'filename': 'LightLineFilename',
  \   'fugitive': 'LightLineFugitive',
  \   'fileformat': 'LightLineFileformat',
  \   'filetype': 'LightLineFiletype',
  \ },
  \ 'component_expand': {
  \   'linter_warnings': 'lightline#ale#warnings',
  \   'linter_errors': 'lightline#ale#errors',
  \ },
  \ 'component_type': {
  \   'linter_warnings': 'warning',
  \   'linter_errors': 'error',
  \ },
  \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '', 'right': '' },
  \ }
let g:lightline#ale#indicator_warnings = ' '
let g:lightline#ale#indicator_errors = ' '
function! LightLineMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction
function! LightLineFilename()
  let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
  let modified = &modified ? ' +' : ''
  return filename . modified
endfunction
function! LightLineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction
function! LightLineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction
function! LightLineFugitive()
  let _ = FugitiveHead()
  return strlen(_) ? ' '._ : ''
endfunction

" markdown
" " set to 1, nvim will open the preview window after entering the markdown buffer
" default: 0
let g:mkdp_auto_start = 0

" set to 1, the nvim will auto close current preview window when change
" from markdown buffer to another buffer
" default: 1
let g:mkdp_auto_close = 1

" set to 1, the vim will refresh markdown when save the buffer or
" leave from insert mode, default 0 is auto refresh markdown as you edit or
" move the cursor
" default: 0
let g:mkdp_refresh_slow = 0

" set to 1, the MarkdownPreview command can be use for all files,
" by default it can be use in markdown file
" default: 0
let g:mkdp_command_for_global = 0

" set to 1, preview server available to others in your network
" by default, the server listens on localhost (127.0.0.1)
" default: 0
let g:mkdp_open_to_the_world = 0

" use custom IP to open preview page
" useful when you work in remote vim and preview on local browser
" more detail see: https://github.com/iamcco/markdown-preview.nvim/pull/9
" default empty
let g:mkdp_open_ip = ''

" specify browser to open preview page
" for path with space
" valid: `/path/with\ space/xxx`
" invalid: `/path/with\\ space/xxx`
" default: ''
let g:mkdp_browser = ''

" set to 1, echo preview page url in command line when open preview page
" default is 0
let g:mkdp_echo_preview_url = 0

" a custom vim function name to open preview page
" this function will receive url as param
" default is empty
let g:mkdp_browserfunc = ''

" options for markdown render
" mkit: markdown-it options for render
" katex: katex options for math
" uml: markdown-it-plantuml options
" maid: mermaid options
" disable_sync_scroll: if disable sync scroll, default 0
" sync_scroll_type: 'middle', 'top' or 'relative', default value is 'middle'
"   middle: mean the cursor position alway show at the middle of the preview page
"   top: mean the vim top viewport alway show at the top of the preview page
"   relative: mean the cursor position alway show at the relative positon of the preview page
" hide_yaml_meta: if hide yaml metadata, default is 1
" sequence_diagrams: js-sequence-diagrams options
" content_editable: if enable content editable for preview page, default: v:false
" disable_filename: if disable filename header for preview page, default: 0
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false,
    \ 'disable_filename': 0,
    \ 'toc': {}
    \ }

" use a custom markdown style must be absolute path
" like '/Users/username/markdown.css' or expand('~/markdown.css')
let g:mkdp_markdown_css = ''

" use a custom highlight style must absolute path
" like '/Users/username/highlight.css' or expand('~/highlight.css')
let g:mkdp_highlight_css = ''

" use a custom port to start server or empty for random
let g:mkdp_port = ''

" preview page title
" ${name} will be replace with the file name
let g:mkdp_page_title = '「${name}」'

" recognized filetypes
" these filetypes will have MarkdownPreview... commands
let g:mkdp_filetypes = ['markdown']

" set default theme (dark or light)
" By default the theme is define according to the preferences of the system
let g:mkdp_theme = 'light'

" standard keybindings
let mapleader = "\<Space>"
nnoremap <silent> <leader>ea :edit $HOME/.config/alacritty/alacritty.yml<cr>
nnoremap <silent> <leader>et :edit $HOME/.tmux.conf<cr>
nnoremap <silent> <leader>ez :edit $HOME/.zshrc<cr>
nnoremap <silent> <leader>ev :edit $MYVIMRC<cr>
nnoremap <silent> <leader>sv :source $MYVIMRC<cr>
nnoremap <silent> <leader>l :redraw!<cr>:nohl<cr><esc>
nnoremap <silent> <leader>v :vsplit<cr><c-w>l
nnoremap <silent> <leader>h :split<cr><c-w>j
nnoremap <silent> <leader>w :write<cr>
nnoremap <silent> <leader>q :quit<cr>
nnoremap <silent> <c-h> <c-w>h
nnoremap <silent> <c-j> <c-w>j
nnoremap <silent> <c-k> <c-w>k
nnoremap <silent> <c-l> <c-w>l
nnoremap <silent> Y y$
nnoremap <silent> j gj
nnoremap <silent> k gk
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> <c-d> <c-d>zz
nnoremap <silent> <c-u> <c-u>zz
noremap <silent> <leader>sy "*y
cnoremap <c-a> <home>
cnoremap <c-e> <end>
cnoremap <c-f> <right>
cnoremap <c-b> <left>

" fzf
nnoremap <silent> <leader>p :call fzf#run({ 'source': 'rg --files', 'sink': 'e', 'window': 'enew' })<cr>

" rg
nnoremap <leader>a :Rg<space>
nnoremap <silent> <leader>* :Rg "\b<C-R><C-W>\b"<CR>:cw<CR>

" " vim-clap / find files
" nnoremap <silent> <leader>p :Clap files<CR>
" nnoremap <silent> <leader>g :Clap grep<CR>
" nnoremap <silent> <leader>* :Clap grep ++query=<cword><CR>

" " esc closes vim-clap
" let g:clap_insert_mode_only = v:true


" format json
nnoremap <leader>j :%!python -m json.tool<cr>

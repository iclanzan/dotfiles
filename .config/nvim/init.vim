set number
set relativenumber
" Let themes know we are using a dark background
set background=dark
set autoindent
set expandtab
set shiftwidth=2
set softtabstop=2
set nowrap
set smarttab
set nrformats-=octal
" Highlight results as you type.
set incsearch
" Always show statusbar.
set laststatus=2
" Show line and column numbers.
set ruler
set wildmenu
" Show partial command in bottom right corner.
set showcmd
" Show at least 1 more line after the current line.
set scrolloff=1
" Scroll horizontally by 1 column at a time.
set sidescroll=1
" Start scrolling horizontally when 1 column away from the edge.
set sidescrolloff=1
" Character displayed between vertical window splits
set fillchars="vert: "
" Display long lines
set display+=lastline
" Don’t break in the middle of words when wrapping long lines
set linebreak
" Delete comment characters when joining lines.
set formatoptions+=j
" Highlight column 81.
set colorcolumn=81
" Disable highlighting very long lines for performance reasons.
set synmaxcol=160
" Update buffer when Vim thinks file contents might have changed from outside.
set autoread
" Wait a maximum of 100ms for key combos.
set ttimeout
set ttimeoutlen=0
" Delay after typing before running commands to update stuff on screen.
set updatetime=250
" Do not restore options when restoring a session.
set sessionoptions-=options
" Disable intro message.
set shortmess=I

" Enable spell checker for markdown files
autocmd FileType markdown setlocal spell

" Enable line wrapping for markdown files
autocmd FileType markdown setlocal wrap

" Disable column color in markdown files
autocmd FileType markdown setlocal colorcolumn=""

" Set JSON filetype to files Vim doesn’t know about.
au BufRead,BufNewFile .eslintrc setfiletype json
au BufRead,BufNewFile .babelrc setfiletype json

" Highlight current line but only in active window.
au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
au WinLeave * setlocal nocursorline

" Autoinstall vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.vim/plugged')

Plug 'jszakmeister/vim-togglecursor'
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'osyo-manga/vim-anzu'
Plug 'Lokaltog/vim-easymotion'
Plug 'terryma/vim-multiple-cursors'
Plug 'wellle/targets.vim'
Plug 'PeterRincker/vim-argumentative'
Plug 'Raimondi/delimitMate'
Plug 'terryma/vim-expand-region'
Plug 'ervandew/supertab'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'elzr/vim-json'
Plug 'junegunn/vim-easy-align'
Plug 'mhinz/vim-signify'
Plug 'pangloss/vim-javascript'
Plug 'groenewege/vim-less'
Plug 'benekastah/neomake'
Plug 'editorconfig/editorconfig-vim'
Plug 'vifm/vifm.vim'
Plug 'tomtom/tcomment_vim'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
" Plug 'Yggdroot/indentLine'
Plug 'mxw/vim-jsx'
Plug 'junegunn/goyo.vim'
Plug 'SirVer/ultisnips'

call plug#end()

function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

function! s:RootDir()
  let root = systemlist('git rev-parse --show-toplevel')[0]
  return v:shell_error ? {} : {'dir': root}
endfunction
com! -nargs=* AgProj
  \ call fzf#vim#ag(<q-args>, extend(s:RootDir(), g:fzf#vim#default_layout))

function! s:ProjectFiles()
  let root = systemlist('git rev-parse --show-toplevel')[0]
  if v:shell_error
    return s:warn('Not in git repo')
  endif
  return fzf#run(fzf#vim#wrap(extend({
  \ 'source':  'git ls-files -oc --exclude-standard',
  \ 'dir':     root,
  \ 'options': '-m --prompt "Project> "'
  \}, g:fzf#vim#default_layout)))
endfunction
com! ProjectFiles
  \ call s:ProjectFiles()

" Configure UltiSnips
let g:UltiSnipsEditSplit = 'vertical'
let g:UltiSnipsSnippetsDir="~/.config/nvim/UltiSnips"
" Do not look for SnipMate files.
let g:UltiSnipsEnableSnipMate = 0


nnoremap <C-P> :<C-U>ProjectFiles<CR>
nnoremap <C-K> :<C-U>Buffers<CR>
nnoremap <C-J> :<C-U>AgProj<Space>

let g:vifm_exec_args = '-c "set tuioptions=p"'

let g:signify_vcs_list = ['git']

let g:indentLine_concealcursor=0

let g:vim_json_syntax_conceal=0

" let g:gruvbox_termcolors=16
let g:gruvbox_sign_column='bg0'
" let g:gruvbox_contrast_dark='hard'
let g:gruvbox_invert_selection=0
let g:neomake_error_sign={'texthl': 'GruvboxRedSign'}
let g:neomake_warning_sign={'texthl': 'GruvboxYellowSign'}
colorscheme gruvbox

highlight link SignifySignChange GruvboxYellowSign

highlight Cursors guibg='#458588' guifg='#ebdbb2'
highlight link multiple_cursors_cursor Cursors
highlight link CtrlPPrtCursor Cursors
" Make terminal cursor red to distinguish from edit cursor.
highlight TermCursor guifg='#fb4934'

" Disable trailing whitespace detection; it slows down editor
let g:airline#extensions#whitespace#enabled = 0

let g:airline#extensions#default#layout = [
      \ [ 'a', 'b', 'c' ],
      \ [ 'x', 'z', 'warning' ]
      \ ]

let g:airline_mode_map = {
      \ '__' : '-',
      \ 'n'  : 'N',
      \ 'i'  : 'I',
      \ 'R'  : 'R',
      \ 'c'  : 'C',
      \ 'v'  : 'V',
      \ 'V'  : 'V',
      \ '' : 'V',
      \ 's'  : 'S',
      \ 'S'  : 'S',
      \ '' : 'S',
      \ }

let g:airline_left_sep=''
let g:airline_right_sep=''

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_symbols.readonly = ''

" Make EditorConfig play nice with Fugitive
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_jsx_enabled_makers = ['eslint']

" Use local eslint.
let s:eslint_path = '/Users/sorin/Workspace/webflow/node_modules/.bin/eslint'
let s:eslint_exe = substitute(s:eslint_path, '^\n*\s*\(.\{-}\)\n*\s*$', '\1', '')
let g:neomake_javascript_eslint_exe = s:eslint_exe
let g:neomake_jsx_eslint_exe = s:eslint_exe

autocmd BufWritePost * :Neomake

map <space> <Plug>(easymotion-prefix)

" Toggle between windows with Tab
map <Tab> <C-W>W

let mapleader=","

nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>P <Plug>yankstack_substitute_newer_paste

" map <C-\> :NERDTreeToggle<CR>

nmap n <Plug>(anzu-n-with-echo)
nmap N <Plug>(anzu-N-with-echo)
nmap * <Plug>(anzu-star-with-echo)
nmap # <Plug>(anzu-sharp-with-echo)
nmap <Esc><Esc> <Plug>(anzu-clear-search-status)

" Next previous location (usually lines with errors)
nmap ]l :lnext<CR>
nmap [l :lprev<CR>

" Insert newline when pressing Enter in normal mode.
nmap <CR> i<CR><ESC>

" Copy file path
cmap cp let @* = expand("%:p")

" Change working directory to that of the current file.
cmap cwd lcd %:p:h

" Disable Ex mode binding
nnoremap Q <nop>

" Emacs shortcuts
" start of line
inoremap <C-A>      <Home>
cnoremap <C-A>      <Home>
" back one character
inoremap <C-B>      <Left>
cnoremap <C-B>      <Left>
" delete character under cursor
inoremap <C-D>      <Del>
cnoremap <C-D>      <Del>
" end of line
inoremap <C-E>      <End>
cnoremap <C-E>      <End>
" forward one character
inoremap <C-F>      <Right>
cnoremap <C-F>      <Right>
" recall newer command-line
inoremap <C-N>      <Down>
cnoremap <C-N>      <Down>
" recall previous (older) command-line
inoremap <C-P>      <Up>
cnoremap <C-P>      <Up>
" back one word
inoremap <M-B> <S-Left>
cnoremap <M-B> <S-Left>
" forward one word
inoremap <M-F> <S-Right>
cnoremap <M-F> <S-Right>

" Map to NULL character, works with <S-Space>, <C-@>, etc.
inoremap <NUL> <Esc>
cnoremap <NUL> <Esc>
nnoremap <NUL> i

" Escape insert mode with Ctrl-C, just like exiting command mode.
inoremap <C-C> <Esc>

" Remove search highlighting, reload file, lint, fix sytax highlighting, redraw screen
nnoremap <C-L> :nohlsearch<CR>:edit<CR>:diffupdate<CR>:Neomake<CR>:syntax sync fromstart<CR><C-L>

" Disable arrow keys to encourage faster movements.
inoremap <Left>  <NOP>
inoremap <Right> <NOP>
inoremap <Up>    <NOP>
inoremap <Down>  <NOP>
cnoremap <Left>  <NOP>
cnoremap <Right> <NOP>
cnoremap <Up>    <NOP>
cnoremap <Down>  <NOP>

" In normal mode make them resize windows.
nnoremap <Left> :vertical resize +1<CR>
nnoremap <Right> :vertical resize -1<CR>
nnoremap <Up> :resize -1<CR>
nnoremap <Down> :resize +1<CR>

" Common mistyped commands.
command W w
command Wq wq
command WQ wq
command Q q

function! s:fzf_statusline()
  " Override statusline as you like
  highlight fzf1 ctermfg=161 ctermbg=251
  highlight fzf2 ctermfg=23 ctermbg=251
  highlight fzf3 ctermfg=237 ctermbg=251
  setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
endfunction

autocmd! User FzfStatusLine call <SID>fzf_statusline()

nnoremap <C-\> :<C-U>vsplit \| EditVifm<CR>

" JavaScript goodness
autocmd FileType javascript inoremap (; ();<Esc>hi
autocmd FileType javascript inoremap {; {};<Esc>hi
autocmd FileType javascript inoremap (<CR> (<CR>)<Esc><S-O>
autocmd FileType javascript inoremap {<CR> {<CR>}<Esc><S-O>
autocmd FileType javascript inoremap (;<CR> (<CR>);<Esc><S-O>
autocmd FileType javascript inoremap {;<CR> {<CR>};<Esc><S-O>

let g:terminal_color_0  = '#282828'
" let g:terminal_color_1  = '#cc241d'
" let g:terminal_color_2  = '#98971a'
" let g:terminal_color_3  = '#d79921'
" let g:terminal_color_4  = '#458588'
" let g:terminal_color_5  = '#b16286'
" let g:terminal_color_6  = '#689d6a'
" let g:terminal_color_7  = '#a89984'
let g:terminal_color_1  = '#fb4934'
let g:terminal_color_2  = '#b8bb26'
let g:terminal_color_3  = '#fabd2f'
let g:terminal_color_4  = '#83a598'
let g:terminal_color_5  = '#d3869b'
let g:terminal_color_6  = '#8ec07c'
let g:terminal_color_7  = '#ebdbb2'
let g:terminal_color_8  = '#928374'
let g:terminal_color_9  = '#fb4934'
let g:terminal_color_10 = '#b8bb26'
let g:terminal_color_11 = '#fabd2f'
let g:terminal_color_12 = '#83a598'
let g:terminal_color_13 = '#d3869b'
let g:terminal_color_14 = '#8ec07c'
let g:terminal_color_15 = '#ebdbb2'

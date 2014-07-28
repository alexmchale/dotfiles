" Alex's VIM

set nocompatible        " enable VIM features
set ch=1
set mousehide           " hide the mouse when typing
set shiftwidth=2
set softtabstop=2
set tabstop=24
set smartindent
set expandtab
set ruler
set ai
set background=dark
set nobackup
set nowritebackup
set noswapfile
set bs=2
set cinoptions+=:0g0
set history=50
set gdefault
set showmatch
set matchpairs+=<:>
set showmode
set nowrap
set mouse-=a
set noincsearch
set number
set go-=rL
set wildignore+=*.o,1.8.7,.git,*.obj
set scrolloff=10
set modelines=5
set laststatus=2

" set cursorline
set nocursorline
set nocursorcolumn

" Vundle
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'mattn/webapi-vim'
Bundle 'kchmck/vim-coffee-script'
Bundle 'kien/ctrlp.vim'
Bundle 'mattn/gist-vim'
Bundle 'scrooloose/nerdtree'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-haml'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-vividchalk'
Bundle 'tsaleh/vim-align'
Bundle 'tmhedberg/matchit'
Bundle '2072/PHP-Indenting-for-VIm'
Bundle 'mileszs/ack.vim'
Bundle 'solars/github-vim'
Bundle 'vim-ruby/vim-ruby'
Bundle 'bling/vim-airline'
Bundle 'mustache/vim-mustache-handlebars'
Bundle 'danro/rename.vim'
Bundle 'jtratner/vim-flavored-markdown'
filetype plugin indent on

" Disable all bells
set vb t_vb=""
autocmd VimEnter * set vb t_vb=
au! GuiEnter * set vb t_vb=

" Open on github with `o
nnoremap <C-g> :!echo `git url`/blob/`git rev-parse --abbrev-ref HEAD`/%\#L<C-R>=line('.')<CR> \| xargs open<CR><CR>

" Automatically strip whitespace when saving
"autocmd BufWritePre * :%s/\s\+$//e
"autocmd BufWritePre * :%s/\r//e
"autocmd BufWritePre * :%s/\t/  /e

" Show end of line whitespace as an error
match ErrorMsg / \+$/

" Whitespace cleaning and saving
vmap <C-o> :s/\s\+$//e<CR>:s/\r//e<CR>:s/\t/  /e<CR>:w<CR>
nmap <C-o> :%s/\s\+$//e<CR>:%s/\r//e<CR>:%s/\t/  /e<CR>:w<CR>

if has("gui_running")
  set guifont=Inconsolata:h16
  set showtabline=2
  set guioptions-=T
  set background=dark
  colorscheme vividchalk
else
  set t_Co=256
  set t_te=
  set t_ti=
  colorscheme vividchalk
endif

syntax on
let c_syntax_for_h = 1
let g:netrw_ftpmode = "binary"
let g:netrw_win95ftp = 0
let g:asmsyntax = "nasm"

" Page controls
noremap <C-J> <PageDown>
noremap <C-K> <PageUp>

" Copy & paste
vmap <C-c> :w! ~/.vbuf<CR>
nmap <C-c> :.w! ~/.vbuf<CR>
nmap <C-v> :r ~/.vbuf<CR>

" Define a command for switching Ruby hashes to 1.9 syntax
command! -bar -range=% NotRocket :<line1>,<line2>s/:\(\w\+\)\s*=>/\1:/e
command! -bar -range=% YesRocket :<line1>,<line2>s/\(\w\+\):/:\1 =>/e

" Key support
map!  <BackSpace>
map ; :

" Navigation
nmap <C-n> :qa!<CR>
nmap <C-m> :n<CR>
nmap <C-y> :NERDTreeToggle<CR>
nmap <S-p> :MRU<CR>
nmap <C-u> :set invpaste<CR>

" Editing
nmap <C-i> ciw
vmap <C-i> c

" Configure tag list
let Tlist_Use_Right_Window = 1
let Tlist_Show_One_File = 1

" Custom auto actions
augroup mkd
  autocmd BufRead *.mkd set ai formatoptions=tcroqn2 comments=n:>
augroup END
autocmd BufNewFile,BufRead *.lib set filetype=c
autocmd BufEnter * stopinsert

" Custom Highlighting
highlight LineNr guifg=#777777 guibg=#202020 ctermfg=grey ctermbg=darkgrey
highlight CursorLine guibg=#202020
highlight CursorColumn guibg=#202020

" Resync colors
syn sync fromstart

" Configure ctrlp.vim
let g:ctrlp_custom_ignore = {
  \ 'dir': '\v[\/](\.(git|hg|svn))|(public|tmp)$',
  \ 'file': '\v\.(exe|so|dll)$' }

" Change the gutter color.
highlight LineNr term=bold cterm=NONE ctermfg=White ctermbg=Black gui=NONE guifg=#777777 guibg=#202020
highlight clear SignColumn

" Force the syntax for some common filenames.
au BufReadPost Gemfile set syntax=ruby
au BufReadPost Rakefile set syntax=ruby
au BufReadPost *.task set syntax=ruby
au BufRead,BufNewFile *.csvbuilder setfiletype ruby

" Use GitHub Flavored Markdown syntax highlighting.
augroup markdown
  au!
  au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
augroup END

" Tell Ack.vim to use Ag instead of Ack
let g:ackprg = 'ag --nogroup --nocolor --column'

" Enable spell-check for Markdown files
autocmd BufRead,BufNewFile *.md,*.markdown setlocal spell

let g:airline_inactive_collapse=1

highlight DiffAdd cterm=none ctermfg=Black ctermbg=83 gui=none guifg=Black guibg=#ddffdd
highlight DiffDelete cterm=none ctermfg=Black ctermbg=1 gui=none guifg=Black guibg=#ffdddd
highlight DiffChange cterm=none ctermfg=Black ctermbg=192 gui=none guifg=Black guibg=#ffffdd
highlight DiffText cterm=none ctermfg=Black ctermbg=184 gui=none guifg=Black guibg=Magenta

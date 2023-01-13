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
set wildignore+=*.o,1.8.7,.git,*.obj,*/tmp/*,*.zip,*.swp,*.min.js
set scrolloff=10
set modeline
set modelines=5
set laststatus=2
set nocursorline
set nocursorcolumn
set maxmempattern=100000

" Vundle
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'mattn/webapi-vim'
Plugin 'kchmck/vim-coffee-script'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'mattn/gist-vim'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-haml'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-vividchalk'
Plugin 'tsaleh/vim-align'
Plugin 'tmhedberg/matchit'
Plugin '2072/PHP-Indenting-for-VIm'
Plugin 'mileszs/ack.vim'
Plugin 'vim-ruby/vim-ruby'
Plugin 'bling/vim-airline'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'danro/rename.vim'
Plugin 'tpope/vim-abolish'
" Plugin 'jtratner/vim-flavored-markdown'
Plugin 'slim-template/vim-slim'
Plugin 'Keithbsmiley/swift.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
" Plugin 'vim-scripts/mru.vim'
Plugin 'sukima/xmledit'
Plugin 'trevorrjohn/vim-obsidian'
Plugin 'fatih/vim-go'
" Plugin 'gabrielelana/vim-markdown'
" Plugin 'scrooloose/syntastic'
" Color Schemes
Plugin 'KKPMW/moonshine-vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'rust-lang/rust.vim'
call vundle#end()
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

if has("gui_running")
  set guifont=InputMono\ Light:h16
  set showtabline=2
  set guioptions-=T
  set background=dark
  colorscheme vividchalk
else
  set t_Co=256
  set t_te=
  set t_ti=
  "colorscheme obsidian
  "colorscheme moonshine
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

" Configure NERDTree
let NERDTreeWinSize = 50

" Navigation
nmap <C-n> :qa!<CR>
nmap <C-m> :n<CR>
nmap <C-y> :NERDTreeToggle<CR>
nmap <C-o> :CtrlPMRU<CR>
nmap <C-p> :CtrlP<CR>
nmap <C-u> :set invpaste<CR>

" Editing
nmap <C-i> ciw
vmap <C-i> c

" Whitespace cleaning and saving
vmap \w :s/\s\+$//e<CR>:s/\r//e<CR>:s/\t/  /e<CR>:w<CR>
nmap \w :%s/\s\+$//e<CR>:%s/\r//e<CR>:%s/\t/  /e<CR>:w<CR>

" Configure tag list
let Tlist_Use_Right_Window = 1
let Tlist_Show_One_File = 1

" Custom auto actions
augroup mkd
  autocmd BufRead *.mkd set ai formatoptions=tcroqn2 comments=n:>
augroup END
autocmd BufNewFile,BufRead *.lib set filetype=c
autocmd BufEnter * stopinsert
autocmd BufWritePre *.jsx :%s/class=/className=/e
"autocmd BufWritePre * :%s/subscribers/subscribers/e

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

" Search from CWD instead of project root
let g:ctrlp_working_path_mode = 'w'

" Change the gutter color.
highlight LineNr term=bold cterm=NONE ctermfg=White ctermbg=Black gui=NONE guifg=#777777 guibg=#202020
highlight clear SignColumn

" Force the syntax for some common filenames.
au BufReadPost Gemfile set syntax=ruby
au BufReadPost Rakefile set syntax=ruby
au BufReadPost *.task set syntax=ruby
au BufRead,BufNewFile *.csvbuilder setfiletype ruby
au BufRead,BufNewFile *.json.jbuilder set ft=ruby
au BufRead,BufNewFile *.go set ts=4 sw=4 syntax=go softtabstop=0 noexpandtab
au BufRead,BufNewFile *.java set ts=4 sw=4 syntax=java softtabstop=0 expandtab
au BufRead,BufNewFile Makefile set ts=4 sw=4 syntax=make softtabstop=0 noexpandtab

" Bindings for go.
au BufRead,BufNewFile *.go nmap \t :GoTest<CR>
au BufRead,BufNewFile *.go nmap \T :GoTestFunc<CR>

" Force the syntax for Perl, hard tabs.
autocmd FileType perl set ts=4 sw=4 syntax=perl softtabstop=0 noexpandtab
autocmd FileType php set ts=4 sw=4 syntax=php softtabstop=0 noexpandtab

" Use GitHub Flavored Markdown syntax highlighting.
augroup markdown
  au!
  au BufNewFile,BufRead *.md,*.markdown setlocal filetype=markdown
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

" Enable RuboCop if available
let g:syntastic_ruby_checkers = ['rubocop', 'mri']

" Custom key bindings **
nmap \l :setlocal number!<CR>
"nmap \p :set paste!<CR>
nmap \r :SyntasticCheck<CR>
nmap \v :set paste<CR>:r !pbpaste<CR>:set nopaste<CR>
imap \v <Esc>:set paste<CR>m'a<C-R>=system('pbpaste')<CR><Esc>:set nopaste<CR>a
nmap \c :.w !pbcopy<CR><CR>
vmap \c :<Esc>`>a<CR><Esc>mx`<i<CR><Esc>my'xk$v'y!pbcopy<CR>u
nmap S ysiw

let g:go_fmt_command = "goimports"



let g:NERDDefaultAlign = 'left'
let g:NERDSpaceDelims = 1
let g:NERDTrimTrailingWhitespace = 1
let g:NERDCommentEmptyLines = 1


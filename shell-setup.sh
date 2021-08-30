
# SETUP STARTING

MYDIR=$HOME/.tmp/.atm

mkdir -p "$MYDIR"

if [ ! -d $MYDIR/.vim/bundle/Vundle.vim ]; then
  git clone https://github.com/VundleVim/Vundle.vim.git $MYDIR/.vim/bundle/Vundle.vim
fi

cat > $MYDIR/.vimrc <<EOF

" Start Vundle.

set nocompatible
filetype off
set rtp+=$MYDIR/.vim/bundle/Vundle.vim
call vundle#begin('$MYDIR/.vim/bundle')

Plugin 'VundleVim/Vundle.vim'
Plugin 'kchmck/vim-coffee-script'
Plugin 'ctrlpvim/ctrlp.vim'
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
Plugin 'vim-ruby/vim-ruby'
Plugin 'bling/vim-airline'
Plugin 'slim-template/vim-slim'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'fatih/vim-go'
Plugin 'scrooloose/nerdcommenter'
Plugin 'rust-lang/rust.vim'
Plugin 'mileszs/ack.vim'

call vundle#end()
filetype plugin indent on

let g:go_version_warning = 0

" Finish Vundle.

EOF

alias vim="vim -u $MYDIR/.vimrc"
vim +PluginInstall +qall

pushd $MYDIR/.vim/bundle/vim-go ; git checkout --quiet v1.16 ; popd

cat >> $MYDIR/.vimrc <<EOF

set nocompatible
set ch=1
set mousehide
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

" Disable all bells
set vb t_vb=""
autocmd VimEnter * set vb t_vb=
au! GuiEnter * set vb t_vb=

map!  <BackSpace>
map ; :

" Show end of line whitespace as an error
match ErrorMsg / \+\$/

syntax on

" Page controls
noremap <C-J> <PageDown>
noremap <C-K> <PageUp>

" Define a command for switching Ruby hashes to 1.9 syntax
command! -bar -range=% NotRocket :<line1>,<line2>s/:\(\w\+\)\s*=>/\1:/e
command! -bar -range=% YesRocket :<line1>,<line2>s/\(\w\+\):/:\1 =>/e

" Editing
nmap <C-i> ciw
vmap <C-i> c
nmap <C-y> :NERDTreeToggle<CR>
nmap <C-o> :CtrlPMRU<CR>
nmap <C-p> :CtrlP<CR>

syn sync fromstart

" Force the syntax for some common filenames.
au BufReadPost Gemfile set syntax=ruby
au BufReadPost Rakefile set syntax=ruby
au BufReadPost *.task set syntax=ruby
au BufRead,BufNewFile *.csvbuilder setfiletype ruby
au BufRead,BufNewFile *.json.jbuilder set ft=ruby
au BufRead,BufNewFile *.go set ts=4 sw=4 syntax=go softtabstop=0 noexpandtab
au BufRead,BufNewFile *.java set ts=4 sw=4 syntax=java softtabstop=0 expandtab
au BufRead,BufNewFile Makefile set ts=4 sw=4 syntax=make softtabstop=0 noexpandtab
au FileType perl set ts=4 sw=4 syntax=perl softtabstop=0 noexpandtab
au FileType php set ts=4 sw=4 syntax=php softtabstop=0 noexpandtab

colorscheme vividchalk

let g:go_version_warning = 0
let g:go_fmt_command = "goimports"
let g:ctrlp_working_path_mode = "a"
let g:ackprg = 'ag --nogroup --nocolor --column'

nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

EOF

cat > $MYDIR/.gitconfig <<EOF

[user]
  name = Alex McHale
  email = amchale@drh.net

[color]
  diff = auto
  status = auto
  branch = auto
  interactive = auto
  ui = auto

[alias]
  c   = commit --edit --verbose
  ci  = commit
  co  = checkout
  cb  = checkout -b
  s   = status --short --branch --untracked=all
  sn  = status --short --branch --untracked=no
  sd  =! "git s . | grep -v '^## ' | cut -c 4- | cut -d'/' -f1 | uniq"
  bc  = difftool --dir-diff --find-renames
  p   = pull --rebase
  m   = merge --no-ff
  up  = pull --rebase --autostash

[color "diff"]
  meta = blue
  frag = magenta
  old = red
  new = green

[core]
  editor = /usr/bin/vim

[mergetool]
  prompt = false

[github]
  user = alexmchale

[filter "media"]
  required = true
  clean = git media clean %f
  smudge = git media smudge %f

[filter "lfs"]
  clean = git-lfs clean %f
  smudge = git-lfs smudge %f
  required = true

[credential]
  helper = cache --timeout=3600
EOF

cat > "$MYDIR/gl" <<'EOF'
#!/usr/bin/env ruby

require "shellwords"

(_, username, repository) = `git remote -v | grep github.com | head -1`.match(%r|github.com[:/](.*?)/(.*?).git|).to_a

args     = ARGV.map { |arg| Shellwords.escape(arg) }.join(" ")
log      = `git log --color=always --date="short" --format="%H %Cgreen%s%Cblue%d %Cred(%aN %ad)" #{ args }`
prefixed = log.lines.map { |line| "\e[0;31mhttps://github.com/#{ username }/#{ repository }/commit/#{ line.strip }" }.join("\n")

puts prefixed
EOF
chmod 755 "$MYDIR/gl"

export GIT_AUTHOR_NAME="Alex McHale"
export GIT_AUTHOR_EMAIL="amchale@drh.net"
export GIT_COMMITTER_NAME="Alex McHale"
export GIT_COMMITTER_EMAIL="amchale@drh.net"

export ACK_OPTIONS="--follow --type-add=ruby=.haml,.rake,.gemspec,.builder --type-add=css=.sass,.scss,.less --type-add=js=.pjs --type-set=markdown=.markdown,.md,.mdown --type-set=actionscript=.as --type-set=cucumber=.feature --type-set=rdoc=.rdoc --ignore-dir=.idea --ignore-dir=tmp --ignore-dir=log --ignore-dir=vendor --type-add=js=.coffee"

export EDITOR=vim

alias gl="$MYDIR/gl"
alias gs="git status --short --branch"
alias gd="git diff"
alias gds="git diff --staged"
alias gla="git log --date=\"short\" --format=\"%Cred%h %Cgreen%s%Cblue%d %Cred(%aN %ad)\""
alias git="HOME=$MYDIR `which git`"
alias ducks="du -shc * | sort -hr | head -20"

if /bin/ls --version > /dev/null 2>&1; then
  alias ls="ls --color=auto"
else
  alias ls="ls -G"
fi

set -o vi

# Define the ANSI colors.
export         CLEAR="\033[00m"
export           RED="\033[0;31m"
export     LIGHT_RED="\033[1;31m"
export         GREEN="\033[0;32m"
export   LIGHT_GREEN="\033[1;32m"
export         GREEN="\033[0;32m"
export   LIGHT_GREEN="\033[1;32m"
export        YELLOW="\033[0;33m"
export  LIGHT_YELLOW="\033[1;33m"
export          BLUE="\033[0;34m"
export    LIGHT_BLUE="\033[1;34m"
export       MAGENTA="\033[0;35m"
export LIGHT_MAGENTA="\033[1;35m"
export         WHITE="\033[1;37m"
export    LIGHT_GRAY="\033[0;37m"

# Set the prompts.
export PS1="\[\033[G\]\[$BLUE\][\[$LIGHT_GREEN\]\H \[$LIGHT_YELLOW\]\w\[$BLUE\]]\[$BLUE\] atm \$? \$ \[$CLEAR\]"
export PS2="> "
export PS4="+ "

# SETUP COMPLETE

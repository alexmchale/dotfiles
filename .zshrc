### Configure rbenv shims ###

eval "$(/usr/local/bin/rbenv init -)"

### Functions ###

function ruby_version {
  if which rbenv &> /dev/null; then
    ruby -v | cut -d ' ' -f 2
  fi
}

function git_branch_name {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/*\1/'
}

function rprompt_details {
  echo "$(git_branch_name) $(ruby_version)" | sed -e 's/^ *//' -e 's/ *$//'
}

# Move up the directory tree until we're in the root of a git project.
function cdg {
  while [ 1 ]; do

    if [ "/" = "`pwd`" ]; then
      return
    fi

    if [ -e ".git" ]; then
      return
    fi

    cd ..

  done
}

# Print a nice diff of unstaged files.
function gd {
  git diff --color -M $* | less -rFX
}

# Print a nice diff of staged files.
function gds {
  gd --staged $*
}

# Prepare Rails test database.
function prepare-test-db {
  RAILS_ENV=test bundle exec rake db:drop && RAILS_ENV=test bundle exec rake db:create && bundle exec rake db:migrate && bundle exec rake db:test:prepare
}

# Send my public key to the target server.
function send-my-public-key {
  cat ~/.ssh/id_rsa.pub | ssh $1 'mkdir -p ~/.ssh ; cat - >> ~/.ssh/authorized_keys ; chmod -R go-rwx ~/.ssh'
}

# Send the current repository changes to a remote host.
function send-studio-changes-to {
  local HOST="$1"
  cdg
  git status -s | cut -c 4- | xargs -I {} scp {} $HOST:/var/hvmail/studio/{}
  ssh $HOST svc -t /service/hvmail-studio-worker
  ssh $HOST touch /var/hvmail/studio/tmp/restart.txt
}

# Run Test::Unit files, using turn.
function t {
  FILES="$*"
  SEARCH=`echo $FILES | grep -oEi '^/([^ /]*)/$' | cut -d/ -f 2`

  if [ ! -z "$SEARCH" ]; then
    FILES=`find test -name '*_test.rb' -type f | grep "$SEARCH"`
    RAILS_ENV=test bundle exec turn -D -I test $FILES
  elif [ -z "$FILES" ]; then
    RAILS_ENV=test bundle exec turn -D -I test test/unit/ test/functional/
  else
    RAILS_ENV=test bundle exec turn -R -I test $FILES
  fi
}

# Run the tests with the given name.
function tn {
  NAME="$*"

  RAILS_ENV=test bundle exec turn -R -I test -n "$NAME" test/unit/ test/functional/
}

### Hooks ###

#function precmd {
#  PREV_RET_VAL=$?
#
#  export PROMPT="%F{green}%m %F{yellow}%~%F{blue}"
#
#  if [ $PREV_RET_VAL -eq 0 ] || [ -z "$PREV_RET_VAL" ]; then
#    export PROMPT="$PROMPT %F{blue}→%F{none} "
#  else
#    export PROMPT="$PROMPT %F{red}→%F{none} "
#  fi
#}

bindkey -v

bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward

function git_custom_status {
  echo ""
}

#function zle-line-init zle-keymap-select {
#  PREV_RET_VAL=$?
#  VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]% %{$reset_color%}"
#  #PS1="%F{blue}⟪ %{$fg_bold['yellow'']}%n%F{blue}@%F{yellow}%m %F{green}%~%F{yellow}${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}$(git_custom_status) %F{blue}⟫ %F{reset}"
#
#  zle reset-prompt
#}

autoload -U colors && colors
function precmd {
  export PROMPT="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg_no_bold[yellow]%}%1~ %{$reset_color%}%#"
  export PROMPT="%{$fg_bold[blue]%}⟪ %{$fg_bold[yellow]%}%n%{$reset_color%}%F{blue}@%{$fg_bold[yellow]%}%m %F{green}%~%F{yellow}${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}$(git_custom_status) %{$fg_bold[blue]%}⟫ %{$fg_no_bold[white]%}"
}

#zle -N zle-line-init
#zle -N zle-keymap-select
#export KEYTIMEOUT=1

### Aliases ###

alias apti='sudo apt-get install'
alias apts='sudo apt-cache search'
alias autotest="bundle && bake db:migrate && bake db:test:prepare && RAILS_ENV=test bake db:schema:load && be autotest"
alias avm="ssh root@amchale.drh.net -t exec screen -D -RR"
alias b="bundle"
alias bake="bundle exec rake"
alias be="bundle exec"
alias br="bundle exec rspec"
alias bundle="ruby -S bundle"
alias cuke-modified="cuke \`git status --untracked-files --porcelain | grep '.feature$' | cut -b 4-\`"
alias cuke="RAILS_ENV=test bundle exec cucumber --format CucumberSpinner::ProgressBarFormatter --require features"
alias fvim='mvim -S ~/.vim/fullscreen.vim'
alias gemi='ruby -S gem install --no-ri --no-rdoc --remote'
alias gems='ruby -S gem search --remote'
alias gemu='ruby -S gem uninstall --all --executables'
alias gls='git log --date="short" --format="%Cred%h %Cgreen%s%Cblue%d"'
alias gla='git log --date="short" --format="%Cred%h %Cgreen%s%Cblue%d %Cred(%aN %ad)"'
alias gs='git s'
alias la="ls -a"
alias ll='ls -l'
alias mvim-merge-conflicts="grep -l -r '<<<<<<<' $GREP_SEARCH_PATH | xargs grep -l -r '>>>>>>>' | xargs grep -l -r '=======' | xargs mvim -p"
alias ssh-drh="ssh -t amchale@vpn.drh.net exec sudo /usr/bin/ssh -i /home/greenarrow_rw/.ssh/id_rsa"
alias t-all="clear && prepare-test-db && t && cuke"
alias tt='tt++ ~/.tintinrc'
alias vim-migration="vim \`git status -s db/migrate | cut -b 4-\`"
alias pwgen='curl -k -2 https://mail.drh.net/cgi-bin/get_password.cgi'
alias rspec-modified="bundle exec rspec \`git status --untracked-files --porcelain | grep '_spec.rb$' | cut -b 4-\`"
alias ag='ag --pager="less -r -X -F"'

### Use GNU ls if it's available ###

if [ -x /usr/local/bin/gls ]; then
  alias ls='/usr/local/bin/gls --color=auto -Fh'
else
  alias ls='ls --color=auto -Fh'
fi

### Add extra zsh configuration ###

source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

### Include ~/.zsh/secret.zsh if it exists ###

if [ -f "$HOME/.zsh/secret.zsh" ]; then
  source ~/.zsh/secret.zsh
fi

### Configuration ###

HISTFILE=~/.histfile
HISTSIZE=1000000
SAVEHIST=1000000
setopt autocd extendedglob notify
unsetopt beep
bindkey -v
zstyle :compinstall filename '/Users/alexmchale/.zshrc'
autoload -U compinit
compinit -C
export PATH="/Users/alexmchale/pebble-dev/PebbleSDK-current/bin:/Applications/RubyEncoder.app/Contents/MacOS:$HOME/src/drh/tools/bin:$HOME/bin:$HOME/.git-extras/bin:/usr/local/bin:/usr/local/sbin:/usr/local/share/npm/bin:$PATH"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
bindkey \^U backward-kill-line
export EDITOR="vim"
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line
export GOPATH="$HOME/src/go"
setopt localoptions rmstarsilent

### Display archey if available ###

archey --color 2> /dev/null

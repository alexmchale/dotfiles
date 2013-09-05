#!/bin/bash

GREP_SEARCH_PATH="Gemfile app bin config db/schema.rb db/migrate lib test public spec features"

# Install all of the basic RubyGems that should be everywhere.
function gemb {
  gem install bundler
  gem install heroku taps powder awesome_print wirble
}

# Remove all existing RubyGems and install just what the current app needs.
function rebundle {
  gem list | cut -f1 -d' ' | xargs gem uninstall -aIx
  gemb
  rbenv rehash
  bundle
  rbenv rehash
}

function current-time {
  echo -n `date +"%l:%M"`
}

function git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/*\1/'
}

hg_branch() {
  hg prompt > /dev/null 2>&1 && hg prompt "{status}{branch}" 2> /dev/null
}

function repo_prompt {
  GIT="$(git_branch)"
  HG="$(hg_branch)"

  if [ ! -z "$GIT" ]; then
    echo -n " $GIT"
  elif [ ! -z "$HG" ]; then
    echo -n " $HG"
  fi
}

function rvm_prompt {
  local gemset=$(echo $GEM_HOME | awk -F'@' '{print $2}')
  [ "$gemset" != "" ] && gemset="@$gemset"
  local version=$(echo $MY_RUBY_HOME | awk -F'/' '{print $NF}')
  local full="$version$gemset"
  [ "$full" != "" ] && echo "$full"
}

function rbenv_prompt {
  rbenv version | cut -d' ' -f1
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

# Search the git project you're in.
function rg {
  STARTED_IN="`pwd`"

  while [ "/" != "`pwd`" ]; do

    if [ -e ".git" ]; then
      grep -n -s -r "$*" --exclude="swfobject.js" --exclude="jquery-*.js" $GREP_SEARCH_PATH
      break
    fi

    cd ..

  done

  cd "$STARTED_IN"
}

# Tell Pow to restart the project you're currently in.
function repow {
  STARTED_IN="`pwd`"

  while [ "/" != "`pwd`" ]; do

    if [ -e ".git" ]; then
      touch "tmp/restart.txt"
      break
    fi

    cd ..

  done

  cd "$STARTED_IN"
}

# Search the rails project you're in and mvim all the matches.
function rg-mvim {
  STARTED_IN="`pwd`"

  while [ "/" != "`pwd`" ]; do

    if [ -e ".git" ]; then
      grep -n -s -r "$*" $GREP_SEARCH_PATH
      grep -n -s -r -l "$*" $GREP_SEARCH_PATH | xargs mvim -p
      break
    fi

    cd ..

  done

  cd $STARTED_IN
}

# Search the rails project you're in and vim all the matches.
function rg-vim {
  STARTED_IN="`pwd`"

  while [ "/" != "`pwd`" ]; do

    if [ -e ".git" ]; then
      grep -n -s -r "$*" $GREP_SEARCH_PATH
      grep -n -s -r -l "$*" $GREP_SEARCH_PATH | xargs -n 1 vim
      break
    fi

    cd ..

  done

  cd $STARTED_IN
}

function prepare-test-db {
  RAILS_ENV=test bundle exec rake db:drop && RAILS_ENV=test bundle exec rake db:create && bundle exec rake db:migrate && bundle exec rake db:test:prepare
}

function http-tgz {
  curl "$1" | tar xvz
}

function send-my-public-key {
  cat ~/.ssh/id_rsa.pub | ssh $1 'mkdir -p ~/.ssh ; cat - >> ~/.ssh/authorized_keys ; chmod -R go-rwx ~/.ssh'
}

function auto-ssh {
  while true; do
    ssh -t "$1" exec screen -R -DD
    sleep 2
  done
}

function deploy {
  local REMOTE="$1"
  local BRANCH="$2"
  local APP="`git remote -v | grep '(push)' | grep $REMOTE | perl -p -e 's/.*\sgit@.*:(.*)\.git\s.*/\1/g'`"

  if [ -z "$BRANCH" ]; then
    BRANCH="master"
  fi

  if [ -z "$APP" ]; then
    echo "deploy [remote]"
    echo "deploy [remote] [branch]"
  else
    git push origin $BRANCH &&
    git push $REMOTE $BRANCH:master &&
    heroku run rake db:migrate --app $APP &&
    heroku restart --app $APP &&
    heroku logs --tail --app $APP
  fi
}

# Clone a Heroku db from one instance to another using a local temporary
# PostgreSQL database.
function clone_h2h {
  local SRC="$1"
  local DST="$2"
  local TABLES="$3"

  if [ -z "$SRC" ] || [ -z "$DST" ]; then
    echo "clone_h2h [source app] [destination app]"
  else
    # Generate a temporary database name.
    local TEMPFILE=`mktemp -t DBCLONE`
    local DB=$(basename $TEMPFILE)
    rm -rf $TEMPFILE
    local URL="postgres://localhost/$DB"

    createdb $DB

    if [ -z "$TABLES" ]; then
      heroku db:pull $URL --app $SRC --confirm $SRC
      heroku db:push $URL --app $DST --confirm $DST
    else
      heroku db:pull --tables $TABLES $URL --app $SRC --confirm $SRC
      heroku db:push --tables $TABLES $URL --app $DST --confirm $DST
    fi

    dropdb $DB
  fi
}

# Push the local copy of GA out to my VM.
function ga_all {
  local SERVER="root@amchale.drh.net"

  pushd ~/Dropbox/Projects/drh
  rsync -avz -e ssh greenarrow-mta greenarrow-studio --exclude=".git" "$SERVER:/usr/local/src/"
  ssh $SERVER 'cd /usr/local/src/greenarrow-mta/webapp ; make install-h'
  popd
}

function ga_mta_h {
  local SERVER="root@amchale.drh.net"

  pushd ~/Dropbox/Projects/drh/greenarrow-mta/webapp
  rsync -avz -e ssh --exclude=".git" h "$SERVER:/usr/local/src/greenarrow-mta/webapp/"
  ssh $SERVER 'cd /usr/local/src/greenarrow-mta/webapp ; make install-h'
  popd

  open "http://amchale.drh.net/greenarrowadmin"
}

function ga_mta_rails {
  local SERVER="root@amchale.drh.net"

  cd ~/drh
  rsync -avz -e ssh greenarrow-mta --exclude=".git" "$SERVER:/usr/local/src/"
  ssh $SERVER 'killall -9 ruby'
  ssh $SERVER 'cd /usr/local/src/greenarrow-mta/webapp ; make install-h'
  ssh $SERVER 'cd /usr/local/src/greenarrow-mta/rails && bundle && bundle exec rake db:migrate && bundle exec unicorn -p 3000'
}

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

function tn {
  NAME="$*"

  RAILS_ENV=test bundle exec turn -R -I test -n "$NAME" test/unit/ test/functional/
}

function sc {
  ssh -t "$1" exec screen -D -RR
}

function clone_staging_db {
  db="greenarrow-studio_development"
  echo "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname='$db'" | psql
  dropdb $db &&
  createdb $db &&
  ssh root@staging.drh.net pg_dump --no-owner --no-privileges --no-acl -U greenarrow greenarrow \> alex-ga.dmp &&
  scp -C root@staging.drh.net:alex-ga.dmp /tmp/ga.dmp &&
  perl -p -i -e "s/ offset integer/ offset1 integer/g" /tmp/ga.dmp &&
  perl -p -i -e "s/\\+ offset\\)/+ offset1)/g" /tmp/ga.dmp &&
  perl -p -i -e "s/STRICT offset FROM/STRICT offset1 FROM/g" /tmp/ga.dmp &&
  psql $db < /tmp/ga.dmp &&
  rm -f /tmp/ga.dmp
}

function send-studio-changes-to {
  local HOST="$1"
  cdg
  git status -s | cut -c 4- | xargs -I {} scp {} $HOST:/var/hvmail/studio/{}
  ssh $HOST svc -t /service/hvmail-httpd /service/hvmail-studio-worker
}

function rails {
  if [ -x script/rails ]; then
    script/rails $*
  else
    /usr/bin/env rails $*
  fi
}

# Configure ls.
GNU_LS_OPTIONS="--color=auto -Fh"
if [ -f "$HOME/Homebrew/bin/gls" ]; then
  alias ls="$HOME/Homebrew/bin/gls $GNU_LS_OPTIONS"
elif [ -f "/usr/local/bin/gls" ]; then
  alias ls="/usr/local/bin/gls $GNU_LS_OPTIONS"
else
  alias ls="ls $GNU_LS_OPTIONS"
fi

# Configure Vim alias for MacOSX.
if [ -e "$HOME/Applications/MacVim.app/Contents/MacOS/Vim" ]; then
  alias vim="$HOME/Applications/MacVim.app/Contents/MacOS/Vim"
fi

# Configure aliases.
alias gems='ruby -S gem search --remote'
alias gemi='ruby -S gem install --no-ri --no-rdoc --remote'
alias gemu='ruby -S gem uninstall --all --executables'
alias gs='git status'
alias gls="git log --pretty=oneline"
alias resume='screen -D -RR'
alias apts='sudo apt-cache search'
alias apti='sudo apt-get install'
alias tt='tt++ ~/.tintinrc'
alias fvim='mvim -S ~/.vim/fullscreen.vim'
alias resume='exec screen -D -RR'
alias rm.orig="find . -name '*.orig' -exec rm -i {} \\;"
alias la="ls -a"
alias gitx="open /Applications/GitX.app ."
alias bake="bundle exec rake"
alias be="bundle exec"
alias b="bundle"
alias bundle="ruby -S bundle"
alias wrangle='/usr/bin/ruby ~/Dropbox/Projects/personal/ep_wrangler/bin/wrangle'
alias autotest="bundle && bake db:migrate && bake db:test:prepare && RAILS_ENV=test bake db:schema:load && be autotest"
alias zeus="ssh zeus.local -t exec screen -D -RR"
alias avm="ssh root@amchale.drh.net -t exec screen -D -RR"
alias cuke="RAILS_ENV=test bundle exec cucumber --format CucumberSpinner::ProgressBarFormatter --require features"
alias cuke-modified="cuke \`git status --untracked-files --porcelain | grep '.feature$' | cut -b 4-\`"
alias mvim-merge-conflicts="grep -l -r '<<<<<<<' $GREP_SEARCH_PATH | xargs grep -l -r '>>>>>>>' | xargs grep -l -r '=======' | xargs mvim -p"
alias force-update-amchale="cd ~/src/drh/studio ; git push amchale-dev ; ssh root@amchale.drh.net 'cd /usr/local/src/greenarrow-studio-next && git checkout . && git reset --hard && rake db:migrate && rake assets:precompile && svc -t /service/hvmail-httpd && svc -t /service/hvmail-studio-worker'"
alias pg="psql greenarrow-studio_development"
alias zeus-budget="ssh zeus.local -t exec screen -D -RR -S budget"
alias zeus-ga="ssh zeus.local -t exec screen -D -RR -S ga"
alias ssh-drh="ssh -t amchale@vpn.drh.net exec sudo /usr/bin/ssh -i /home/greenarrow_rw/.ssh/id_rsa"
alias vim-migration="vim \`git status -s db/migrate | cut -b 4-\`"
alias t-all="clear && prepare-test-db && t && cuke"

# Configure paths.
function add-paths { for p in "$@"; do export PATH="$p:$PATH"; done; }
function add-home-paths { for p in "$@"; do export PATH="$HOME/$p:$PATH"; done; }
add-paths      /usr/local/share/npm/bin /usr/local/redis /opt/java/bin /usr/local/lib/ruby/gems/1.8/bin /usr/local/bin
add-home-paths .rbenv-linux/bin .rbenv/bin .ruby-build/bin .scripts .git-extras/bin Homebrew/bin Applications bin bin/bin

# Set the rbenv path.
if [ "`uname`" = "Linux" ]; then
  export RBENV_ROOT="$HOME/.rbenv-linux"
fi

# Install rbenv shims.
eval "$(rbenv init -)"

# Configure environment options.
export EDITOR="vim"
export GEM_PRIVATE_KEY="$HOME/.ssh/gem-private_key.pem"
export GEM_CERTIFICATE_CHAIN="$HOME/.ssh/gem-public_cert.pem"
export RUBY_HEAP_MIN_SLOTS=1000000
export RUBY_HEAP_SLOTS_INCREMENT=1000000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=1000000000
export RUBY_HEAP_FREE_MIN=500000

# Load privaterc if it is available.
[[ -s "$HOME/.privaterc" ]] && source "$HOME/.privaterc"

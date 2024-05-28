export HOMEBREW_ROOT='/opt/homebrew'

typeset -gU path
path=(
    "$HOME/.local/bin"
    "$HOMEBREW_ROOT/opt/postgresql@15/bin"
    "$HOMEBREW_ROOT/bin"
    /usr/local/bin
    /usr/local/sbin
    /usr/bin
    /usr/sbin
    /sbin
    "$HOME/.emacs.d/bin"
    "$HOMEBREW_ROOT/opt/coreutils/libexec/gnubin"
    "$HOME/.cargo/bin"
    $path
)

export OBJC_DISABLE_INITIALIZE_FORK_SAFETY='YES'
export LSP_USE_PLISTS='t'

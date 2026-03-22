# -- Directory Navigation --
setopt AUTO_CD              # Type a directory name to cd into it without typing 'cd'
setopt AUTO_PUSHD           # Automatically push directories onto the directory stack on cd
setopt PUSHD_IGNORE_DUPS    # Don't push duplicate directories onto the stack
setopt PUSHD_SILENT         # Don't print the directory stack after pushd/popd

# -- Completion --
setopt COMPLETE_IN_WORD     # Allow completion from the middle of a word, not just the end
setopt ALWAYS_TO_END        # Move cursor to end of word after completing, even mid-word
setopt PATH_DIRS            # Perform path search even on commands with slashes
setopt AUTO_MENU            # Show completion menu on successive tab presses
setopt AUTO_LIST            # Automatically list choices on ambiguous completion
setopt AUTO_PARAM_SLASH     # Add a trailing slash when completing a directory name

# -- Input / Interaction --
setopt CORRECT              # Offer to correct mistyped commands (e.g. "Did you mean ...?")
setopt INTERACTIVE_COMMENTS # Allow comments (#) in interactive shell sessions
setopt NO_BEEP              # Disable terminal bell / beep on errors

# -- Prompt --
setopt PROMPT_SUBST         # Enable parameter/command substitution in prompt strings

# -- Globbing --
setopt EXTENDED_GLOB        # Enable extended glob operators like ^, ~, and # for pattern matching
setopt GLOB_DOTS            # Include dotfiles in glob results without needing an explicit dot
setopt NO_CASE_GLOB         # Make globbing case-insensitive
setopt NUMERIC_GLOB_SORT    # Sort filenames numerically (e.g. file2 before file10)

# -- History --
setopt HIST_FCNTL_LOCK        # Use fcntl system call for history file locking (better performance)
setopt APPEND_HISTORY         # Append new history entries to the history file instead of overwriting
setopt SHARE_HISTORY          # Share command history across multiple terminal sessions in real-time
setopt HIST_IGNORE_DUPS       # Don't record duplicate commands in history
setopt HIST_IGNORE_SPACE      # Don't record commands that start with a space in history
setopt HIST_EXPIRE_DUPS_FIRST # When trimming history, remove duplicates first, then oldest entries
setopt HIST_FIND_NO_DUPS      # Don't display duplicate entries when searching history with Ctrl-R
setopt HIST_REDUCE_BLANKS     # Remove extra blanks from each command line before saving to history

# Load zmv — a powerful batch-rename/move utility built into zsh.
# -U: suppress alias expansion when loading. -z: force zsh-style autoloading.
# Usage example: zmv '(*).txt' '$1.md' renames all .txt files to .md.
autoload -Uz zmv

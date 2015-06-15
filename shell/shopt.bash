# shopt options

# history
shopt -s histappend # Append to the Bash history file, rather than overwriting it
shopt -s cmdhist # Saves multiline command as one history entry

# completion
shopt -s dotglob # Dotfile globbing (pathname expansion)
shopt -s nocaseglob # Case-insensitive globbing (pathname expansion)
shopt -s cdspell # Autocorrect typos in path names when using `cd`
#shopt -s dirspell # Autocorrect typos in path names when using autocompletion
shopt -s no_empty_cmd_completion # Do not search the PATH for possible completions on an empty line

# background jobs
#shopt -s checkjobs # Do not exit even if jobs are stopped

# debugging
#set -o noclobber # can not overwrite whole files
#set -x # print every command before it is run
#set -e # exit upon reaching nonzero return value (not good for the interactive terminal or sourced scripts; it should only be run in a subshell)

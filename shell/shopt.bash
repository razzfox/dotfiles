# shopt options
shopt -s histappend # Append to the Bash history file, rather than overwriting it
shopt -s nocaseglob # Case-insensitive globbing (pathname expansion)
#shopt -s dotglob # Dotfile globbing (pathname expansion)
shopt -s cdspell # Autocorrect typos in path names when using `cd`
#shopt -s dirspell # Autocorrect typos in path names when using autocompletion
#shopt -s checkjobs # Do not exit even if jobs are stopped
shopt -s cmdhist # Saves multiline command as one history entry
shopt -s no_empty_cmd_completion # Do not search the PATH for possible completions on an empty line

# set options
#set -o noclobber # can not overwrite whole files

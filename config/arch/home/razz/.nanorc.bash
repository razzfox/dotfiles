## Copied from the example for Bourne shell scripts.
##
syntax "bash" "\.bash$"
header "^#!.*/(ba|k|pdk)?sh[-0-9_]*"
icolor brightgreen "^[0-9A-Z_]+\(\)"
color green "\<(case|do|done|elif|else|esac|exit|fi|for|function|if|in|local|read|return|select|shift|then|time|until|while)\>"
color green "(\{|\}|\(|\)|\;|\]|\[|`|\\|\$|<|>|!|=|&|\|)"
color green "-[Ldefgruwx]\>"
color green "-(eq|ne|gt|lt|ge|le|s|n|z)\>"
color brightblue "\<(cat|cd|chmod|chown|cp|echo|env|export|grep|install|let|ln|make|mkdir|mv|rm|sed|set|tar|touch|umask|unset)\>"
icolor brightred "\$\{?[0-9A-Z_!@#$*?-]+\}?"
color cyan "(^|[[:space:]])#.*$"
color brightyellow ""(\\.|[^"])*"" "'(\\.|[^'])*'"
color ,green "[[:space:]]+$"
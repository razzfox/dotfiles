# Filesize
du() {
  $(which du) --dereference-args --human-readable --summarize --one-file-system "$@"
}

# Filesize including dotfiles
du_all() {
  $(which du) --dereference-args --human-readable --all "$@"
}

# Filesize sorted decreasing
du_sort() {
  du "$@" | sort -hr
}

which tree >/dev/null 2>/dev/null || return 1
du_tree() {
  $(which tree) -axhF --du -I '.git|.npm|.gem|.android|.atom|.local|Library' "$@"
}
# Filesize
du() {
  $(which du) --dereference-args --human-readable --summarize --one-file-system "$@"
}

# Filesize including dotfiles
du_all() {
  du --all "$@"
}

# Filesize sorted decreasing
du_sort() {
  du "$@" | sort -hr
}

du_tree() {
  $(which tree) -axhF --du -I '.git|.npm|.gem|.android|.atom|.local|Library' "$@"
}

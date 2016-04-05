# Filesize
du() {
  $(which du) --dereference-args --human-readable --summarize --one-file-system "$@"
}

# Filesize including dotfiles
du_all() {
  $(which du) --all --dereference-args --human-readable --max-depth=1 --one-file-system "$@"
}

# Filesize sorted decreasing
du_sort() {
  du "$@" | sort -hr
}

du_tree() {
  $(which tree) -axhF --du -I '.git|.npm|.gem|.android|.atom|.local|Library' "$@"
}

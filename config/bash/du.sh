du=$(which du)

# Filesize
du() {
  $du -LHcsxh "$@"
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
  tree -axhF --du -I '.git|.npm|.gem|.android|.atom|.local|Library' "$@"
}

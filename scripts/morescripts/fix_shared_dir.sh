# Captial X means only for directories, not execute files

# Set 775 dirs and 664 files (add rwx to u and g) (add rx to o) (subtract w from o)
chmod -R ug+rwX,o+rX,o-w "$@"

# Set 755 dirs and 644 files (add rwx to u) (add rx to g and o) (subtract w from o)
#chmod -R u+rwX,go+rX,go-w "$@"

# Set 777 dirs and 666 files (add rwx to u and g and o)
#chmod -R ugo+rwX "$@"

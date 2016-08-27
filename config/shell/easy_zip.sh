easy_extract() {
local c e i

(($#)) || return $?

for i; do
  c=''
  e=1

  if test ! -r $i; then
      echo "easy_extract: Error: the file '$i' is unreadable." >/dev/stderr
      continue
  fi

  case $i in
#            *.t@(deb|tar|tbz2|tgz|txz|rpm|gz|lz|xz|b@(2|z?(2))|a@(z|r?(.@(Z|bz?(2)|gz|lzma|xz)))))
#                   c='bsdtar xvf';;
  *.7z)  c='7z x';;
  *.Z)   c='uncompress';;
  *.bz2) c='bunzip2';;
  *.exe) c='cabextract';;
  *.gz)  c='gunzip';;
  *.rar) c='unrar x';;
  *.xz)  c='unxz';;
  *.zip) c='unzip';;
  *.lzma) c='xz -d';;
  *.pkg) c='xar -xf';;
  *)     echo "easy_extract: Error: the file '$i' is not recognized." >/dev/stderr
         continue;;
  esac

  command $c "$i"
  e=$?
done

return $e
}


easy_zip() {
  $(which zip) -r "${1%/}.zip" "${1}"
}

zip() {
  easy_zip "$@"
}


easy_7z() {
  $(which 7z) a -t7z -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on "${1%/}.7z" "${1}"
}

7z() {
  easy_7z "$@"
}


# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
easy_targz() {
    local tmpFile="${@%/}.tar"
    tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1

    size=$(
        # OSX
        stat -f"%z" "${tmpFile}" 2>/dev/null
        # GNU
        stat -c"%s" "${tmpFile}" 2>/dev/null
    )

    local cmd=""
    if (( size < 52428800 )) && hash zopfli 2>/dev/null; then
        # the .tar file is smaller than 50 MB and Zopfli is available; use it
        cmd="zopfli"
    else
        if hash pigz 2>/dev/null; then
            cmd="pigz"
        else
            cmd="gzip"
        fi
    fi

    echo "Compressing tarball using '${cmd}'…"
    "${cmd}" -v "${tmpFile}" || return 1
    [ -f "${tmpFile}" ] && rm "${tmpFile}"
    echo "Archive '${tmpFile}.gz' created successfully."
}

targz() {
  easy_targz "$@"
}

tar_list() {
  tar vtzf "$@"
}

easy_undeb() {
  mkdir "${1}"
  cd "${1}"
  ar p "${1}" data.tar.gz | tar vxzf
}


# Extracting (untar) an archive using tar command
#
# Extract a *.tar file using option xvf
# Extract a tar file using option x as shown below:
#
# $ tar xvf archive_name.tar
# x – extract files from archive
# Extract a gzipped tar archive ( *.tar.gz ) using option xvzf
# Use the option z for uncompressing a gzip tar archive.
#
# $ tar xvfz archive_name.tar.gz
# Extracting a bzipped tar archive ( *.tar.bz2 ) using option xvjf
# Use the option j for uncompressing a bzip2 tar archive.
#
# $ tar xvfj archive_name.tar.bz2
# Note: In all the above commands v is optional, which lists the file being processed.

# Listing an archive using tar command
#
# View the tar archive file content without extracting using option tvf
# You can view the *.tar file content before extracting as shown below.
#
# $ tar tvf archive_name.tar
# View the *.tar.gz file content without extracting using option tvzf
# You can view the *.tar.gz file content before extracting as shown below.
#
# $ tar tvfz archive_name.tar.gz
# View the *.tar.bz2 file content without extracting using option tvjf
# You can view the *.tar.bz2 file content before extracting as shown below.
#
# $ tar tvfj archive_name.tar.bz2

# Extract a single file from tar, tar.gz, tar.bz2 file
#
# To extract a specific file from a tar archive, specify the file name at the end of the tar xvf command as shown below. The following command extracts only a specific file from a large tar file.
#
# $ tar xvf archive_file.tar /path/to/file
# Use the relevant option z or j according to the compression method gzip or bzip2 respectively as shown below.
#
# $ tar xvfz archive_file.tar.gz /path/to/file
#
# $ tar xvfj archive_file.tar.bz2 /path/to/file

# Extract a single directory from tar, tar.gz, tar.bz2 file
#
# To extract a single directory (along with it’s subdirectory and files) from a tar archive, specify the directory name at the end of the tar xvf command as shown below. The following extracts only a specific directory from a large tar file.
#
# $ tar xvf archive_file.tar /path/to/dir/
# To extract multiple directories from a tar archive, specify those individual directory names at the end of the tar xvf command as shown below.
#
# $ tar xvf archive_file.tar /path/to/dir1/ /path/to/dir2/
# Use the relevant option z or j according to the compression method gzip or bzip2 respectively as shown below.
#
# $ tar xvfz archive_file.tar.gz /path/to/dir/
#
# $ tar xvfj archive_file.tar.bz2 /path/to/dir/

# Extract group of files from tar, tar.gz, tar.bz2 archives using regular expression
#
# You can specify a regex, to extract files matching a specified pattern. For example, following tar command extracts all the files with pl extension.
#
# $ tar xvf archive_file.tar --wildcards '*.pl'
# Options explanation:
#
# –wildcards *.pl – files with pl extension

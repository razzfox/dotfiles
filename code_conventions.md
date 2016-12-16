####

  echo x${output}x

  # Trim leading whitespaces
  output="${output##*( )}"

  echo x${output}x

  # trim trailing whitespaces
  output="${output%%*( )}"

  echo x${output}x

####

# Find file extension
ext="${file##*\.}" # string after last '.'

####

# Put these lines at the top and bootom of your bashrc
PS4='+ $(date "+%s.%N")\011 '
exec 3>&2 2>$HOME/bashstart.$$.log
set -x

# code

set +x
exec 2>&3 3>&-

####

# Mac OS X: Darwin refers to the underlying kernel and terminal utilities put together by Apple, which has slightly different (BSD?) implementations than Arch Linux (GNU?). Shell scripts are called OSX when they refer more to the OS X userspace.

####

# Arch Linux: Upgrade fails. Usually because it's been a while since last upgrade.
# Try upgrading important packages by themselves: arch-linux-keyring pgp linux
# Perhaps write a scriptc that searches for "base" upgrades, and runs that first, then runs upgrade again.

####

# Keep a directory empty in git (and ignore new files)
echo '# Ignore everything in this directory
*
# Except this file
!.gitignore
' >> EMPTY_DIRECTORY/.gitignore

# Keep an empty directory in git (but allow files later)
touch EMPTY_DIRECTORY/.gitignore

####

# Aliases are passe. Use functions instead!
#alias cd 'cd \!*; ls' # This is how to include args in an alias

# A function:
buzz() {
  echo "buzz"
}

####
# Escape UTF-8 characters into their 3-byte format
escape() {
	printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u)
}

# Create a data URL from a file
data_url() {
	local mimeType=$(file -b --mime-type "$1")
	if test $mimeType = text/*; then
		mimeType="${mimeType};charset=utf-8"
	fi
	echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}
####

# Scripts should be 'sourced' into the shell, because they use shell language. trying to run a script as an executable is just a layer of obfuscation in a subprocess.

####

# Dotfiles should stay as terminal settings, not full-blown portable programs.
The difference between a shell function and a script is that a shell function is an atomic action typed by hand and returned to the terminal immediately.
A script takes more time or is usually executed as/by another process.
A shell function should be merely a modified way to start another program.
A script is defined by the programming logic it is written in, and is a program in itself.

####

IFS="$(printf '\n\t')"

####

# WARNING: Setting environment variables from URI this way is insecure!
IFS="&"
#set -- $QUERY_STRING
#array=($@)
#array=($QUERY_STRING)
#for var in "${array[@]}"; do
for var in $QUERY_STRING; do
  #IFS="="
  #set -- "$var"
  #declare "$1=$2"
  declare "$var"
done

####

# URL Decode: Replace %NN with \xNN and pass the lot to printf -b, which will decode hex
test -z "$location" && location=/ || printf -v location '%b' "${location//%/\\x}"

####

# A shell's functions are to assist in executing files, managing files, managing processes, and serving files+pipes to processes, to aid in browsing/displaying/editing.
It excells at doing this locally and remotely because it is a text interface, but smart command+file completion, suggestion, and highlighting is paramount.

####

# Currently I use '&>/dev/null' and '>file' without a space in the name. The shortcuts '&2' and '&1' are not very clear, but are sometimes unavoidable.

####

# Only export variables that might be used by other programs. Do not export variables specific to the functionality of the shell

####

# Shell script naming priority should try to be as specific as possible (shell name whenever possible). Scripts are sourced in this order:
Does it work only in your SHELL?
  or is it important for any tty or shell (SH)?
Does it work only on your distro (ID)?
  or is it important for any of the same kernel (OS)?
SHELL (program) > SH (any shell) > ID (distro) > OS (kernel)
  example: .bash > .sh > .arch > .linux

####

if connected; then
  true
fi

test ! connected && echo "Error: No internet connectivity." >/dev/stderr && return 1

####

# This automatically passes the last command's return value
test $EUID = 0 || return

# This allows you to print an error and then return a nonzero value
test $EUID != 0 && echo "Error: You must be root to do this." >/dev/stderr && return 1

####

# Always use '&&' and '||' together in that order!
(if) true  && (then) <running> || <not run>
(if) false && <not run> || (else) <running>

# Put another way:
true  && <running> || <not run>
false && <not run> || <running>

# Remember that this only works if the second term CAN NOT FAIL
# This would be very bad, because all three commands are run:
true:<run> && false:<run> || <running>

####

unset ANSWER
echo -n "Do this thing? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  true
fi

####

unset ANSWER
echo -n "Do you agree with this? [yes or no]: "
read ANSWER
case $ANSWER in
  [yY] | [yY][Ee][Ss] )
    true
    ;;

  [nN] | [n|N][O|o] )
    false
    ;;
  *) echo "Error: Invalid input" >/dev/stderr
esac

####

# Secure temporary files
tmp=${TMPDIR:-/tmp}
tmp=${tmp}/tempdir.$$
$(umask 077 && mkdir $tmp) || echo "Error: Could not create temporary directory." >/dev/stderr && return 1
Basic shell mistakes: relying on quoting errors to relay arguments (instead of using arrays), convoluted grep+sed pipes (instead of awk), echo -e (instead of printf), ancient backtick format (instead of $()) 

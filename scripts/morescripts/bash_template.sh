#!/usr/bin/env bash

# Set Bash unofficial strict mode
# set -e will exit the script if any command returns a non-zero status code
# use "|| true" for a command that must return nonzero but not stop the program
# set -u will prevent using an undefined variable
# set -o pipefail will force pipelines to fail on the first non-zero status code
set -euo pipefail
IFS=$'\n\t'

#/ Usage:
#/ Description:
#/ Examples:
#/ Options:
#/   --help: Display this help message
usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }
expr "$*" : ".*--help" > /dev/null && usage

readonly LOG_FILE="/tmp/$(basename "$0").log"
info()    { echo "[INFO]    $*" | tee -a "$LOG_FILE" >&2 ; }
warning() { echo "[WARNING] $*" | tee -a "$LOG_FILE" >&2 ; }
error()   { echo "[ERROR]   $*" | tee -a "$LOG_FILE" >&2 ; }
fatal()   { echo "[FATAL]   $*" | tee -a "$LOG_FILE" >&2 ; exit 1 ; }

cleanup() {
    # Remove temporary files
    # Restart services
    # ...
}
trap cleanup EXIT

# Script goes here
# ...

#### ShellCheck is the syntax checker for BASH_SOURCE
#sudo pacman -Sy shellcheck

#!/usr/bin/ksh93

########################################################################
#                                                                      #
#               This software is part of the ast package               #
#                 Copyright (c) 2009-2012 Roland Mainz                 #
#                      and is licensed under the                       #
#                 Eclipse Public License, Version 1.0                  #
#                    by AT&T Intellectual Property                     #
#                                                                      #
#                A copy of the License is available at                 #
#          http://www.eclipse.org/org/documents/epl-v10.html           #
#         (with md5 checksum b35adb5213ca9657e911e9befb180842)         #
#                                                                      #
#                                                                      #
#                 Roland Mainz <roland.mainz@nrubsig.org>              #
#                                                                      #
########################################################################

#
# Copyright (c) 2009, 2013, Roland Mainz. All rights reserved.
#

#
# simplefileattributetree1 - build a simple file tree (including file attributes)
#

# Solaris needs /usr/xpg6/bin:/usr/xpg4/bin because the tools in /usr/bin are not POSIX-conformant
export PATH='/usr/xpg6/bin:/usr/xpg4/bin:/bin:/usr/bin'

# Make sure all math stuff runs in the "C" locale to avoid problems
# with alternative # radix point representations (e.g. ',' instead of
# '.' in de_DE.*-locales). This needs to be set _before_ any
# floating-point constants are defined in this script).
if [[ "${LC_ALL-}" != '' ]] ; then
	export \
		LC_MONETARY="${LC_ALL}" \
		LC_MESSAGES="${LC_ALL}" \
		LC_COLLATE="${LC_ALL}" \
		LC_CTYPE="${LC_ALL}"
		unset LC_ALL
fi
export LC_NUMERIC='C'


function add_file_to_tree
{
	nameref treename=$1
	typeset filename=$2
	nameref destnodename=$3
	integer i
	typeset nodepath # full name of compound variable
	typeset -a pe # path elements
	typeset s
	integer si # index in "s"
	typeset ch # single char

	# first built an array containing the names of each path element
	# (e.g. "foo/var/baz" results in an array containing "( 'foo' 'bar' 'baz' )")
	typeset IFS='/'
	pe+=( ${filename} )
	
	[[ ${pe[0]} == '' ]] && pe[0]='/'

	# try to escape special characters which cannot be used within
	# an index value of an associative array
	for (( i=0 ; i < ${#pe[@]} ; i++ )) ; do
		if [[ "${pe[i]}" == ~(A)([\\\*@_]|\[|\]) ]] ; then
			s=''
			for (( si=0 ; si < ${#pe[i]} ; si++ )) ; do
				ch="${pe[i]:si:1}"
				if [[ "${ch}" == ~(A)([\\\*@_]|\[|\]) ]] ; then
					if [[ "${ch}" == '_' ]] ; then
						s+='__'
					else
						# use ksh "\x<hex>" hex-style
						# escape for special shell characters
						# This works in all locales because
						# we only use the ASCII subset here
						s+="$(printf '_x%02.x' "'${ch}")"
					fi
				else
					s+="${ch}"
				fi
			done
			pe[i]="${s}"
		fi
	done

	# walk path described via the "pe" array and build nodes if
	# there aren't any nodes yet
	nodepath='treename'
	for (( i=0 ; i < (${#pe[@]}-1) ; i++ )) ; do
		nameref x="${nodepath}"

		# [[ -v ]] does not work for arrays because [[ -v ar ]]
		# is equal to [[ -v ar[0] ]]. In this case we can
		# use the output of typeset +p x.nodes
		[[ "${ typeset +p x.nodes ; }" == '' ]] && compound -A x.nodes
	
		nodepath+=".nodes[${pe[i]}]"
	done
	
	# insert element
	nameref node="${nodepath}"
	[[ "${ typeset +p node.elements ; }" == '' ]] && compound -A node.elements
	node.elements[${pe[i]}]=(
		filepath="${filename}"
	)
	
	destnodename="${!node}.elements[${pe[i]}]"
	
	return 0
}

function parse_findls
{
	nameref out=$1
	typeset str="$2"
	
	# find -ls on Solaris uses the following output format by default:
	#604302    3 -rw-r--r--   1 test001  users        2678 May  9 00:46 ./httpsresdump

	integer out.inodenum="${str/~(Elrx)(?:
		[[:space:]]*	# ignore leading spaces
		([[:digit:]]+)	# inode number
		[[:space:]]+
		([[:digit:]]+)	# number of blocks in kb
		[[:space:]]+
		([[:alpha:]-]+)	# Unix mode flags
		[[:space:]]+
		([[:digit:]]+)	# number of hardlinks
		[[:space:]]+
		([[:alnum:]]+)	# owner user
		[[:space:]]+
		([[:alnum:]]+)	# owner group
		[[:space:]]+
		([[:digit:]]+)	# filesize in bytes
		[[:space:]]+
		([[:alpha:]]*[[:space:]]+[[:digit:]]*[[:space:]]+[[:digit:]:]+)	# date
		[[:space:]]+
		(.+)		# filename
		)/\1}"
	
	(( ${#.sh.match[@]} == 10 )) || { print -u2 "ASSERT $LINENO" ; exit 1 ; }
	
	# Performance: We use the ".sh.match" indexed array to avoid that we
	# have to do the pattern matching multiple times on the same string
	integer out.kbblocks="${.sh.match[2]}"
	typeset out.mode="${.sh.match[3]}"
	integer out.numlinks="${.sh.match[4]}"
	compound out.owner=(
		typeset user="${.sh.match[5]}"
		typeset group="${.sh.match[6]}"
	)
	integer out.filesize="${.sh.match[7]}"
	typeset out.date="${.sh.match[8]}"
	typeset out.filepath="${.sh.match[9]}"

	(( ${#out.filepath} > 0 )) || { print -u2 "ASSERT $LINENO" ; exit 1 ; }

	return 0
}

function usage
{
	OPTIND=0
	getopts -a "${progname}" "${simplefileattributetree1_usage}" OPT '-?'
	exit 2
}

function main
{	
	compound filetree
	compound appconfig=(
		bool do_benchmarking=false
		compound do_record=(
			bool content=false
			bool filetype=false
		)
	)

	# benchmark data
	compound bench=(
		float start
		float stop
	)

	integer i
	typeset IFS
	
	while getopts -a "${progname}" "${simplefileattributetree1_usage}" OPT ; do 
		case "${OPT}" in
			'b')	appconfig.do_benchmarking=true		;;
			'+b')	appconfig.do_benchmarking=false		;;
			'c')	appconfig.do_record.content=true	;;
			'+c')	appconfig.do_record.content=false	;;
			't')	appconfig.do_record.filetype=true	;;
			'+t')	appconfig.do_record.filetype=false	;;
			*)	usage ;;
		esac
	done
	shift $(( OPTIND-1 ))

	
	# argument prechecks
	if (( $# == 0 )) ; then
		print -u2 -f $"%s: Missing <path> argument.\n" "${progname}"
		return 1
	fi
	
	
	print -u2 -f $"# reading file names...\n"
	while (( $# > 0 )) ; do
		IFS=$'\n'
		typeset -a findls_lines=( $(find "$1" -type f -ls) )
		IFS=$' \t\n'

		shift
	done
	
	
	print -u2 -f $"# building tree for %d files...\n" "${#findls_lines[@]}"
	
	(( appconfig.do_benchmarking )) && (( bench.start=SECONDS ))
	
	for (( i=0 ; i < ${#findls_lines[@]} ; i++ )) ; do
		compound parseddata
		typeset treenodename
		
		# parse "find -ls" output
		parse_findls parseddata "${findls_lines[i]}"
		
		# add node to tree and return it's absolute name in "treenodename"
		add_file_to_tree filetree "${parseddata.filepath}" treenodename
		
		# merge parsed "find -ls" output into tree node
		nameref treenode="${treenodename}"
		treenode+=parseddata
		
		# extras (calculated from the existing values in "parseddata")
		typeset treenode.dirname="${ dirname "${treenode.filepath}" ; }"
		typeset treenode.basename="${ basename "${treenode.filepath}" ; }"
		
		if (( appconfig.do_record.filetype )) ; then
			# Using /usr/(xpg4/)*/bin/file requires a |fork()|+|exec()| which makes the script a few hundred times slower... ;-(
			typeset treenode.filetype="$(file "${treenode.filepath}")"
		fi
		
		if (( appconfig.do_record.content )) ; then
			if [[ -r "${treenode.filepath}" ]] ; then
				# We use an array of compound variables here to support
				# files with holes (and later alternative streams, too)
				compound -a treenode.content
				integer cl=0
				while \
					{
						treenode.content[${cl}]=(
							typeset type="data" # (todo: "add support for "holes" (sparse files))
							typeset -b bin
						)
						read -n1024 treenode.content[${cl}].bin
					} ; do
					(( cl++ ))
				done < "${treenode.filepath}"
				unset treenode.content[${cl}] # remove last (empty) array element
	
				typeset -A treenode.hashsum=(
					[md5]="$(sum -x md5 < "${treenode.filepath}")"
					[sha512]="$(sum -x sha512 < "${treenode.filepath}")"
				)
			
				# we do this for internal debugging only
				if [[ "${ {
						integer j
						for (( j=0 ; j < ${#treenode.content[@]} ; j++ )) ; do
							printf '%B' treenode.content[$j].bin
						done
					} | sum -x sha512 ; }" != "${treenode.hashsum[sha512]}" ]] ; then
					# this should never happen...
					print -u2 -f $"%s: fatal hash mismatch for %s\n" "${progname}" "${treenode.filepath}"
					unset treenode.content treenode.hashsum
				fi
			fi
		fi
	done
	
	(( appconfig.do_benchmarking )) && (( bench.stop=SECONDS ))
	
	# print variable tree
	print -v filetree

	if (( appconfig.do_benchmarking )) ; then
		# print benchmark data
		print -u2 -f $"# time used: %f\n" $((bench.stop - bench.start))
	fi

	return 0
}

# main
builtin basename
builtin dirname
builtin sum

set -o noglob
set -o nounset

typeset progname="${ basename "${0}" ; }"

typeset -r simplefileattributetree1_usage=$'+
[-?\n@(#)\$Id: simplefileattributetree1 (Roland Mainz) 2013-05-12 \$\n]
[-author?Roland Mainz <roland.mainz@nrubsig.org>]
[+NAME?simplefileattributetree1 - generate compound variable tree which contains file names and their attributes]
[+DESCRIPTION?\bsimplefileattributetree1\b is a simple variable tree 
	demo which builds a compound variable tree based on the output
	of /usr/xpg4/bin/file which contains the file name, the file attributes
	and optionally file type and content]
[b:benchmark?Print time needed to generate the tree.]
[c:includecontent?Include the file\'s content in the tree, split into 1kb blocks.]
[t:includefiletype?Include the file type (output of /usr/xpg4/bin/file).]

path

[+SEE ALSO?\bksh93\b(1), \bfile\b(1), \bfind\b(1)]
'

main "$@"
exit $?

# EOF.

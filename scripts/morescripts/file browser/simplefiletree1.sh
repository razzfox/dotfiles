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
# Copyright (c) 2009, 2012, Roland Mainz. All rights reserved.
#

#
# simplefiletree1 - build a simple file tree
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
	typeset treename=$1
	typeset filename=$2
	integer i
	typeset nodepath # full name of compound variable
	typeset -a pe # path elements

	# first built an array containing the names of each path element
	# (e.g. "foo/var/baz" results in an array containing "( 'foo' 'bar' 'baz' )")
	typeset IFS='/'
	pe+=( ${filename} )
	
	[[ ${pe[0]} == '' ]] && pe[0]='/'

	# walk path described via the "pe" array and build nodes if
	# there aren't any nodes yet
	nodepath="${treename}"
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
	[[ "${ typeset +p node.elements ; }" == '' ]] && typeset -a node.elements
	node.elements+=( "${pe[i]}" )
	
	return 0
}

# main
builtin rev

# tree base
compound filetree

# benchmark data
compound bench=(
	float start
	float stop
)

typeset i

# argument prechecks
if (( $# == 0 )) ; then
	print -u2 -f "%s: Missing <path> argument." "$0"
	exit 1
fi

print -u2 "# reading file names"
while (( $# > 0 )) ; do
	IFS=$'\n' ; typeset -a filenames=( $(find "$1" -type f) ) ; IFS=$' \t\n'
	shift
done
print -u2 "# building tree..."

(( bench.start=SECONDS ))

for (( i=0 ; i < ${#filenames[@]} ; i++ )) ; do
	add_file_to_tree filetree "${filenames[i]}"
done

(( bench.stop=SECONDS ))

# print benchmark data
print -u2 -f "# time used: %f\n" $(( bench.stop - bench.start ))

# print tree
print -v filetree

exit 0
# EOF.

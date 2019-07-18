#!/usr/bin/ksh93

########################################################################
#                                                                      #
#               This software is part of the ast package               #
#                 Copyright (c) 2008-2012 Roland Mainz                 #
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
# Copyright (c) 2008, 2012, Roland Mainz. All rights reserved.
#

# Solaris needs /usr/xpg4/bin/ because the tools in /usr/bin are not POSIX-conformant
export PATH='/usr/xpg4/bin:/bin:/usr/bin'

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


# hack for more performance
export LC_ALL='C'

function fatal_error
{
	print -u2 "${progname}: $*"
	exit 1
}

function do_hash_fonts
{
	typeset filename
	typeset md5sum
	typeset tmpdir
	typeset dummy
	typeset xlfd
	typeset i

	egrep -i '\.(bdf|pcf|pmf|pfa|pfb|ttf|ttc|otf|otc)$' |
	egrep -v '/(deleted_files|SCCS)/' |
	while read filename ; do
		#[[ "${filename}" != ~(Eir)\.(bdf|pcf|pmf|pfa|pfb|ttf|ttc|otf|otc) ]] && continue
		#[[ "${filename}" == ~(E)/(deleted_files|SCCS)/ ]] && continue
	
		print -u2 -f "# processing %s ...\n" "$filename"


		if [[ "$filename" == ~(Er)\.bdf ]] ; then
			md5sum="$( /usr/openwin/bin/bdftopcf <"$filename" | sum -x md5 )"
		else
			md5sum="$( sum -x md5 < "$filename" )"
		fi
		nameref node=data.hashnodes["${md5sum}"]

		if [[ "$node" == "" ]] ; then
			typeset node.md5sum="${md5sum}"
			typeset -a node.filenames=( "$filename" )
			
			typeset node.file_type="$( /usr/bin/file "$filename" )"

			## add comment information
			typeset -a node.comments
			strings -a < "$filename" | ggrep -E -i --context=2 "(license|copyright|reserved|rights)" |
				while read i ; do
					node.comments+=( "$i" )
				done
			

			## build XLFD information
			tmpdir="/tmp/fonthashtree_${PPID}_$$"
			(
				set -o errexit

				mkdir "${tmpdir}"
				cp "${filename}" "${tmpdir}"
				cd "${tmpdir}"
				/home/test001/bin/mkfontscale
				/usr/openwin/bin/mkfontdir .
			)

			if [[ -f "${tmpdir}/fonts.dir" ]] ; then
				typeset -a node.xlfd

				while IFS=' ' read dummy xlfd ; do
					[[ "$xlfd" == "" ]] && continue

					node.xlfd+=( "$xlfd" )
				done <"${tmpdir}/fonts.dir"
			fi
			rm -Rf "${tmpdir}"
		else
			node.filenames+=( "$filename" )
			print -u2 "# dup ${md5sum}"
		fi

	done

	print -r -- "$data" |
		sed $'s/^#.*$//;s/^\(//;s/^\)//;s/^\ttypeset -A hashnodes=\(//;s/^\t\)//'  >"${reportfile}"
}

function do_report
{
	typeset index
	typeset s

	eval "data.hashnodes=( $(< "${reportfile}" ) )"

	for index in "${!data.hashnodes[@]}" ; do
#		print -u2 "# Scanning $index ..."
		nameref node=data.hashnodes["${index}"]

		s="${node.filenames[*]}"

		printf "File %s\tpresent in { " "$(basename "${node.filenames[0]}")"
			[[ "$s" == ~(E)/usr/openwin ]] 		&& printf "/usr/openwin, "
			[[ "$s" == ~(E)/usr/dt ]] 		&& printf "/usr/dt, "
			[[ "$s" == ~(E)XW_NV_MWS/xc ]] 		&& printf "XW_NV_MWS/xc, "
			[[ "$s" == ~(E)XW_NV_MWS/open-src ]] 	&& printf "XW_NV_MWS/open-src, "
		printf " }\n"
	done
}


function do_print_duplicate_files
{
	typeset pattern="$1"
	typeset index
	typeset currfilename
	integer i
	integer numfiles
	
	if (( $# != 1 )) || [[ "${pattern}" == "" ]] ; then
		print -u2 "do_print_duplicate_files: Usage: $0 <pattern>"
		return 1
	fi
	
	printf "#### Reporting duplicate files matching '%s':\n" "${pattern}"

	eval "data.hashnodes=( $(< "${reportfile}" ) )"

	for index in "${!data.hashnodes[@]}" ; do
		unset matches || true # remove old array (from previous cycle)
		typeset -a matches
		nameref node=data.hashnodes["${index}"]

		(( numfiles=${#node.filenames[@]} ))
		for (( i=0 ; i < numfiles ; i++ )) ; do
			currfilename="${node.filenames[${i}]}"
			if [[ "${currfilename}" == ${pattern} ]] ; then
				matches+=( "${currfilename}" )
			fi
		done

		(( numfiles=${#matches[@]} ))
		
		# if we only have one entry continue
		(( numfiles < 2 )) && continue
		
		printf "# Duplicate files for node %s (%s) are\n" "${index}" "${matches[0]}"
		for (( i=0 ; i < numfiles ; i++ )) ; do
			printf "\t%s\n" "${matches[${i}]}"
		done
	done
}


function build_xlfd_tree
{
#set -o errexit -o xtrace
	typeset index
	typeset s
	typeset i
	typeset dummy
	typeset a b c d e f
	
	nameref xlfd_tree="$1"
	typeset -A xlfd_tree.l1
	typeset tree_mode="$2"

	eval "data.hashnodes=( $(< "${reportfile}" ) )"

	for index in "${!data.hashnodes[@]}" ; do
		nameref node=data.hashnodes["${index}"]

		for i in "${node.xlfd[@]}" ; do
			IFS='-' read dummy a b c d e f <<<"$i"
			
			if [[ "$a" == "" ]] ; then
				a="$dummy"
			fi
			
			[[ "$a" == "" ]] && a='-'
			[[ "$b" == "" ]] && b='-'
			[[ "$c" == "" ]] && c='-'
						
			if [[ "${xlfd_tree.l1["$a"]}" == "" ]] ; then
			#if ! (unset xlfd_tree.l1["$a"]) ; then
				typeset -A xlfd_tree.l1["$a"].l2
			fi

			if [[ "${xlfd_tree.l1["$a"].l2["$b"]}" == "" ]] ; then
			#if ! (unset xlfd_tree.l1["$a"].l2["$b"]) ; then
				typeset -A xlfd_tree.l1["$a"].l2["$b"].l3
			fi

			if [[ "${!xlfd_tree.l1["$a"].l2["$b"].l3["$c"].entries[*]}" == "" ]] ; then
				typeset -A xlfd_tree.l1["$a"].l2["$b"].l3["$c"].entries
			fi
					
			typeset new_index
			if [[ "${tree_mode}" == "leaf_hash" ]] ; then
				new_index=$(( ${#xlfd_tree.l1["$a"].l2["$b"].l3["$c"].entries[@]}+1 ))
			else
				new_index="${node.md5sum}"

				# skip if the leaf node already exists
				if [[ "${xlfd_tree.l1["$a"].l2["$b"].l3["$c"].entries[${new_index}]}" != "" ]] ; then
					continue
				fi
			fi

			if [[ "${KSH93_NAMEREF_LEAF_BUG_FIXED}" == "true" || "${tree_mode}" != "leaf_license" ]] ; then
				add_xlfd_tree_leaf xlfd_tree.l1["$a"].l2["$b"].l3["$c"].entries[${new_index}] "${index}" "${tree_mode}"
			else
				typeset xlfd_tree.l1["$a"].l2["$b"].l3["$c"].entries[${new_index}].md5sum="${node.md5sum}"
				typeset xlfd_tree.l1["$a"].l2["$b"].l3["$c"].entries[${new_index}].file_type="${node.file_type}"
				typeset -a xlfd_tree.l1["$a"].l2["$b"].l3["$c"].entries[${new_index}].filenames=( "${node.filenames[@]}" )
				typeset -a xlfd_tree.l1["$a"].l2["$b"].l3["$c"].entries[${new_index}].comments=( "${node.comments[@]}" )
				typeset -a xlfd_tree.l1["$a"].l2["$b"].l3["$c"].entries[${new_index}].xlfd=( "${node.xlfd[@]}" )
			fi
		done
	done
	
	return 0	
}

function add_xlfd_tree_leaf
{
	nameref xlfdtree_leafnode="$1"
	nameref data_node=data.hashnodes["$2"]
	typeset add_mode="$3"
	
	case "${add_mode}" in
		"leaf_hash")
			xlfdtree_leafnode="${data_node.md5sum}"
			return 0
			;;
		"leaf_license")
			xlfdtree_leafnode=(
				typeset md5sum="${data_node.md5sum}"
				typeset file_type="${data_node.file_type}"
				typeset -a filenames=( "${data_node.filenames[@]}" )
				typeset -a comments=( "${data_node.comments[@]}" )
				typeset -a xlfd=( "${data_node.xlfd[@]}" )
			)
			return 0
			;;
	esac

	print -u2 -f "ERROR: Unknown mode %s in add_xlfd_tree_leaf\n" "${add_mode}"
	return 1
}

# classify license and store result in node.license_color
function classify_font_license
{
	typeset license_mit=false
	typeset license_public_domain=false
	
	nameref node="$1"
	typeset liccomments="${node.comments[*]}"
	mit_license_str='Permission to use, copy, modify, and distribute this software and its documentation for any purpose and without fee is hereby granted, provided that the above copyright notices appear in all copies and that both those copyright notices and this permission notice appear in supporting documentation, and that the'

	liccomments="${liccomments//COMMENT/}"
	# compress whitespaces and ','
	liccomments="${liccomments//+([[:space:],])/ }"
	mit_license_str="${mit_license_str//+([[:space:],])/ }"

	mit_license_str="${mit_license_str// /.*}"
	mit_license_str="~(Ei)${mit_license_str}"
	
	if [[ "${liccomments}" == ${mit_license_str} ]] ; then
		license_mit=true
	fi

	if [[ "${liccomments}" == ~(Ei)Public\ domain\ font ]] ; then
		license_public_domain=true
	fi
		
	# classify license
	if ${license_mit} || ${license_public_domain}; then
		node.license_color='green'
		return 0
	fi

	if [[ "${node.file_type}" == ~(Ei)(Adobe\ PostScript\ Type\ 1|Adobe\ PostScript\ ASCII\ font) ]] &&
	   [[ "${node.xlfd[*]}" == ~(Ei)adobe-(Helvetica-(Medium|Bold|Oblique|Bold.*Oblique)|Times.*(Bold|Italic|Bold.*Italic)|Symbol|Courier|Courier.*Bold|Courier.*Oblique|Courier.*Bold.*Oblique) ]] ; then
		node.license_color='red'
		return 0
	fi

	if [[ "${node.xlfd[*]}" == ~(Ei)-monotype.*(Times.*New.*Roman|Arial|Courier|Rockwell|Century.*Schoolbook|Gill.*Sans|Corsiva|Rockwell|Bookman|Bembo|Book.*Antiqua|Symbol) ]] ; then
		node.license_color='red'
		return 0
	fi
	
	if [[ "${liccomments}" == ~(Ei)was\ generated\ from\ a\ font\ server ]] ; then
		node.license_color='yellow'
		return 0
	fi
	
	node.license_color='orange'
	return 0
}


# helper function for "do_xlfd_tree"
function print_flat_html_css_style
{			
cat <<EOF
<style type="text/css">
<!--
#font_comment_cell {
	display: block;
	overflow: auto;
	width: 250px;
	height: 75px;
	padding: 0px;
	font-size: 75%;
	font-family: fixed;
}

#font_file_list_cell {
	padding: 3px;
	font-size: 75%;
	font-family: fixed;
}

#font_file_md5hash {
	font-size: 75%;
	font-family: fixed;
}

#color_red {
	background-color: red;
}

#color_orange {
	background-color: orange;
}

#color_yellow {
	background-color: yellow;
}

#color_green {
	background-color: green;
}

#font_xlfd_list_cell {
	display: block;
	overflow: auto;
	width: 250px;
	height: 75px;
	padding: 0px;
}
-->
</style>
EOF
}


function print_flat_html_footer
{
	print '<br />Go back to <a href="index.html">top level</a><br />'
	printf '<br /><span style="font-size: 75%%">Created with %H, %H</span><br />\n' "${progname}" "${.sh.version}"
}

function str2wwwurlencoding
{
	typeset data="$1"
	integer datalen="${#data}"
	typeset c
	typeset out=""

	for ((j=0 ; j < datalen ; j++)) ; do
		c="${data:j:1}"
		case "$c" in
			' ') c="+"   ;;
			'!') c="%21" ;;
			'*') c="%2A" ;;
			"'") c="%27" ;;
			'(') c="%28" ;;
			')') c="%29" ;;
			';') c="%3B" ;;
			':') c="%3A" ;;
			'@') c="%40" ;;
			'&') c="%26" ;;
			'=') c="%3D" ;;
			'+') c="%2B" ;;
			'$') c="%24" ;;
			',') c="%2C" ;;
			'/') c="%2F" ;;
			'?') c="%3F" ;;
			'%') c="%25" ;;
			'#') c="%23" ;;
			'[') c="%5B" ;;
			'\') c="%5C" ;; # we need this to avoid the '\'-quoting hell
			']') c="%5D" ;;
			*)	;;
		esac

		out+="$c"
	done
	
	print -r -- "${out}"
	return 0
}


function do_xlfd_tree
{
#set -o errexit -o xtrace
	typeset xlfd_tree=()
	typeset -A xlfd_tree.l1
	typeset tree_mode="$1"
	typeset print_mode="$2"
	
	print -u2 "# Checking cache..."
	
	[[ ! -f "${reportfile}" ]] && fatal_error "${reportfile} not found."

	typeset reportfile_hash="$(sum -x md5 < "${reportfile}")"
	typeset cache_filename="/tmp/xfonttree001_xlfd_tree_cache_$(logname)_${reportfile_hash}.cpv"

	if [[ ! -f "${cache_filename}" ]] ; then
		print -u2 "# Building tree ..."
		build_xlfd_tree xlfd_tree "${tree_mode}"
		print -r -- "${xlfd_tree}" >"${cache_filename}"
	else
		print -u2 -f "# Using cached tree from %s ..." "${cache_filename}" ; print -u2 ""
		eval "xlfd_tree=$(< "${cache_filename}" )"
	fi
	
	print -u2 "# Building results..."
	case "${print_mode}" in
		"raw_tree")
			print -r -- "${xlfd_tree}"
			;;
		"flat")
			IFS=$'\n' # needed for "sort" call below
			typeset i j k l
			for i in $(printf "%s\n" "${!xlfd_tree.l1[@]}" | sort) ; do
				printf "# Vendor name: %s\n" "$i"

				for j in $(printf "%s\n" "${!xlfd_tree.l1["$i"].l2[@]}" | sort) ; do
					for k in $(printf "%s\n" "${!xlfd_tree.l1["$i"].l2["$j"].l3[@]}" | sort) ; do
						nameref vndnode=xlfd_tree.l1["$i"].l2["$j"].l3["$k"] # font "vendor" node
						
						printf "\t# Vendor font ID: %s\n" "$i/$j/$k"

						for l in $(printf "%s\n" "${!vndnode.entries[@]}" | sort -n) ; do
							nameref node=vndnode.entries["$l"]
							
							# fixme: not done yet
							printf "\t\t# Affected files for md5sum=%s:\n" "${node.md5sum}"
							printf "\t\t\t%s\n" "${node.filenames[@]}"
							printf "\n"
							printf "\t\t\t# License comments are\n"
							printf "\t\t\t\t\t%s\n" "# ${node.comments[@]}"
						done
					done
				done
			done
			;;

		"flat_html")
			IFS=$'\n' # needed for "sort" call below

			typeset i j k l fn
			
			## filter chain begin
			print "## begin filtering..."
			for i in "${!xlfd_tree.l1[@]}" ; do
				for j in "${!xlfd_tree.l1["$i"].l2[@]}" ; do
					for k in "${!xlfd_tree.l1["$i"].l2["$j"].l3[@]}" ; do
						nameref vndnode=xlfd_tree.l1["$i"].l2["$j"].l3["$k"] # font "vendor" node
					
						#printf "\t# Vendor font ID: %s\n" "$i/$j/$k"
			
						for l in "${!vndnode.entries[@]}" ; do
							nameref node=vndnode.entries["$l"]
						
							classify_font_license node

							for fn in "${node.filenames[@]}" ; do
								if [[ "${fn}" != ~(E)x-re_gate_XW_NV_MWS || "${fn}" == ~(Er)\.pmf ]] ; then
									#printf "%s\n" "${!node}"
									unset node
									break
								fi
							done
						done
					
						# Remove empty node...
						if (( ${#vndnode.entries[@]} == 0 )) ; then
							#printf "\t# Removing empty vendor node: %s\n" "$i/$j/$k"
							unset vndnode
						fi
					done

					# Remove empty node...
					if (( ${#xlfd_tree.l1["$i"].l2["$j"].l3[@]} == 0 )) ; then
						#printf "\t# Removing empty vendor node: %s\n" "$i/$j"
						unset xlfd_tree.l1["$i"].l2["$j"]
					fi
				done

				# Remove empty node...
				if (( ${#xlfd_tree.l1["$i"].l2[@]} == 0 )) ; then
					#printf "\t# Removing empty vendor node: %s\n" "$i"
					unset xlfd_tree.l1["$i"]
				fi
			done
			print "## end filtering."
			## filter chain end
			
			
			mkdir -p report
			cd report
			rm -f "fileclass.txt"
			
			{
			print '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">'
			print '<html>'

			print_flat_html_css_style
			
			print '<body>'
			print '<h1>Font License report:</h1>'
			

			### index table
			print '<ul>'
			print '<caption>List 1.1: Font vendor/foundry index for <a href="#anchor_table_1_1">table 1.1</a></caption>'
			for i in $(printf "%s\n" "${!xlfd_tree.l1[@]}" | sort) ; do
				printf '<li><a href="#%H">%H</a><ul>\n' \
					"$(str2wwwurlencoding "anchor_$i")" \
					"$i"
				for j in $(printf "%s\n" "${!xlfd_tree.l1["$i"].l2[@]}" | sort) ; do
					printf '\t<li><a href="#%H">%H</a></li>\n' \
						"$(str2wwwurlencoding "anchor_${i}_${j}")" \
						"$j"
				done
				printf '</ul></li>\n'
			done
			printf '</ul><p />\n'
			
			### main table
			print '<a name="anchor_table_1_1" /><table border="1">'
			print '<caption>Table 1.2: Vendor/font/license comments</caption>'
						
			for i in $(printf "%s\n" "${!xlfd_tree.l1[@]}" | sort) ; do
				typeset vendorid="$i"
				typeset vendor_report_file="vendorid_$(str2wwwurlencoding "${vendorid}").html"

				print '<tr>'
				printf '<td align="top">Vendor name: <a name="%H"><a href="%s">%H</a></a></td>\n' \
					"$(str2wwwurlencoding "anchor_$i")" \
					"$(str2wwwurlencoding "${vendor_report_file}")" \
					"$i"
				
				print '<td>'
				
				{
					print '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">'
					print '<html>'

					print_flat_html_css_style
					
					print '<body>'
					printf '<h1>Font License report for %H:</h1>\n' "${vendorid}"
					
				} >"${vendor_report_file}"

				{
				print '<table border="1">'

				for j in $(printf "%s\n" "${!xlfd_tree.l1["$i"].l2[@]}" | sort) ; do
					printf '<tr><td><a name="%H"><table border="0">\n' \
						"$(str2wwwurlencoding "anchor_${i}_${j}")" 
				
					for k in $(printf "%s\n" "${!xlfd_tree.l1["$i"].l2["$j"].l3[@]}" | sort) ; do
						nameref vndnode=xlfd_tree.l1["$i"].l2["$j"].l3["$k"] # font "vendor" node
						typeset vendorfontid="$i/$j/$k"
						
						typeset vendor_family_report_file="vendorfont_$(str2wwwurlencoding "${vendorfontid}").html"
						
						printf '<a name="%H"></a>\n' \
							"$(str2wwwurlencoding "anchor_${i}_${j}_${k}")"
						
						tmp="$(
						for l in $(printf "%s\n" "${!vndnode.entries[@]}" | sort -n) ; do
							nameref node=vndnode.entries["$l"]
							
							typeset entry_report_file="entry_$(str2wwwurlencoding "${node.md5sum}").html"
													
							case "${node.license_color}" in
								'red')		print '<tr id="color_red">'	;;
								'yellow')	print '<tr id="color_yellow">'	;;
								'orange')	print '<tr id="color_orange">'	;;
								'green')	print '<tr id="color_green">'	;;
								*)		print '<tr id="color_none">'	;;
							esac
							
							{
								printf 'nodemd5=%s\tlicense_color=%s' "${node.md5sum}" "${node.license_color}"
								printf '\tfilename=%s' "${node.filenames[@]}"
								printf '\n'
							} >>"fileclass.txt"
							
							printf '<td id="font_file_list_cell">\n'
							printf '%H<br />\n' "${node.filenames[@]}"
							printf '</td>\n'

							printf '<td id="font_file_md5hash"><a href="%s">%H</a></td>\n' "$(str2wwwurlencoding "${entry_report_file}")" "${node.md5sum}"
							
							printf '<td id="font_comment_cell">\n'
							printf '<pre>'
							printf '%H\n' "${node.comments[@]}"
							printf '</pre>'
							printf '</td>\n'

							#printf '<td id="font_xlfd_list_cell">\n'
							#printf '%H<br />\n' "${node.xlfd[@]}"
							#printf '</td>\n'
								
							print '</tr>'
							
							{
								print '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">'
								print '<html>'

								print_flat_html_css_style
							
								print '<body>'
								
								printf '<h1>Font node %H (<a href="index.html#%H">%H</a>/<a href="index.html#%H">%H</a>/<a href="index.html#%H">%H</a>)</h2>\n' \
									"$l" \
									"$(str2wwwurlencoding "anchor_${i}")" \
									"$i" \
									"$(str2wwwurlencoding "anchor_${i}_${j}")" \
									"$j" \
									"$(str2wwwurlencoding "anchor_${i}_${j}_${k}")" \
									"$k"
								
								printf '<h3>Filenames:</h3>\n'
								printf '<pre>\n'
								printf '\t%H\n' "${node.filenames[@]}"
								printf '</pre>\n'
								printf '<br />\n'

								printf '<h3>Comments:</h3>\n'
								printf '<pre>\n'
								printf '\t%H\n' "${node.comments[@]}"
								printf '</pre>\n'
								printf '<br />\n'

								printf '<h3>XLFDs:</h3>\n'
								printf '<pre>\n'
								printf '\t%H\n' "${node.xlfd[@]}"
								printf '</pre>\n'
								printf '<br />\n'

								print_flat_html_footer
							
								print '</body>'
								print '</html>'
							} >"${entry_report_file}"
						done
						)"
						
						if [[ -z "$tmp" ]] ; then
							print -u2 "# Skipping $vendorfontid"
							continue
						fi
						
						{
							print '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">'
							print '<html>'

							print_flat_html_css_style
							
							print '<body>'
							printf '<h1>Font License report for <a href="%s">%H</a>/%H/%H:</h1>\n' "$(str2wwwurlencoding "${vendor_report_file}")" "$i" "$j" "$k"
							
						} >"${vendor_family_report_file}"
						
						printf '<tr><td id="font_vendor_cell">'
						printf 'Vendor font ID:<br /><a href="%s">%H</a>' "$(str2wwwurlencoding "${vendor_family_report_file}")" "${vendorfontid}"
						printf '</td>\n'

						print '<td>'
						
						{
						print '<table border="1">'
						
						print '<thead>'
						print '<tr>'
						print '<td>Affected files</td>'
						print '<td>MD5 hash</td>'
						print '<td>License comments</td>'
						#print '<td>XLFD</td>'
						print '</tr>'
						print '</thead>'
						
						print '<tbody>'
						print -r -- "$tmp"
						print '</tbody>'
						
						print '</table>'
						} >>"${vendor_family_report_file}.tmp"
						
						cat "${vendor_family_report_file}.tmp"
						
						{
							cat "${vendor_family_report_file}.tmp"
							
							print_flat_html_footer
							
							print '</body>'
							print '</html>'
						} >>"${vendor_family_report_file}"
						
						rm "${vendor_family_report_file}.tmp"
						
						print '</td></tr>'
					done
					
					printf '</table></td></tr>\n'
				done
				
				print '</table>'
				} >>"${vendor_report_file}.tmp"

				cat "${vendor_report_file}.tmp"

				{
					cat "${vendor_report_file}.tmp"
					
					print_flat_html_footer
					
					print '</body>'
					print '</html>'
				} >>"${vendor_report_file}"				

				rm "${vendor_report_file}.tmp"

				print '</td>'

				print '</tr>'
			done
			
			print '</table>'
			
			print_flat_html_footer
			
			print '</body>'
			print '</html>'
			} >"index.html"
			
			print "# Building tarball for license_color GREEN ..."
			typeset -r green_pattern="~(E)license_color=green"
			cat fileclass.txt | while IFS=$'\t' read i j k l m ; do
				[[ "$j" !=  ${green_pattern} ]] && continue
				
				print -r -- "${k/~(El)filename=/}" 
			done |
			(cd .. ; tar -cvf - -I /dev/stdin | bzip2) >fonts_license_color_green.tar.bz2

			print "# Building tarball for license_color { YELLOW, ORANGE } ..."
			typeset -r yellow_orange_pattern="~(E)license_color=(yellow|orange)"
			cat fileclass.txt | while IFS=$'\t' read i j k l m ; do
				[[ "$j" != ${yellow_orange_pattern} ]] && continue
				
				print -r -- "${k/~(El)filename=/}" 
			done  |
			(cd .. ; tar -cvf - -I /dev/stdin | bzip2) >fonts_license_color_yellow_orange.tar.bz2
						
			cd ..
			;;
		*)
			print -u2 -f "ERROR: Unknown mode %s in do_xlfd_tree\n" "${print_mode}"
			return 1
			;;
	esac
	
	return 0
}


function do_print_duplicate_xlfd
{
#set -o errexit -o xtrace
	typeset xlfd_tree=()
	typeset -A xlfd_tree.l1
	typeset tree_mode="$1"
	typeset print_mode="$2"
	
	print -u2 "# Building tree..."
	build_xlfd_tree xlfd_tree "leaf_license"
	
	print -u2 "# Building results..."

	IFS=$'\n' # needed for "sort" call below
	typeset i j k l1 l2
	for i in $(printf "%s\n" "${!xlfd_tree.l1[@]}" | sort) ; do
		for j in $(printf "%s\n" "${!xlfd_tree.l1["$i"].l2[@]}" | sort) ; do
			for k in $(printf "%s\n" "${!xlfd_tree.l1["$i"].l2["$j"].l3[@]}" | sort) ; do
				nameref vndnode=xlfd_tree.l1["$i"].l2["$j"].l3["$k"] # font "vendor" node
				
				printf "\t# Vendor font ID: %s\n" "$i/$j/$k"

				for l1 in "${!vndnode.entries[@]}" ; do					
					for l2 in "${!vndnode.entries[@]}" ; do
						# fixme: why does this check not work (we need to compare the nodes's filenames below as workaround)
						[[ "${l1}" == "${l2}" ]] && continue
						
						nameref node_l1=vndnode.entries["${l1}"]
						nameref node_l2=vndnode.entries["${l2}"]
						
						for xlfd1 in "${node_l1.xlfd[@]}" ; do
							for xlfd2 in "${node_l2.xlfd[@]}" ; do
								if [[ "${xlfd1}" == "${xlfd2}" && \
									"${node_l1.filenames[*]}" != "${node_l2.filenames[*]}" ]] ; then
									printf "Node %s (file=%s) and node %s (file=%s) share xlfd='%s'\n" \
										"${node_l1.md5sum}" "${node_l1.filenames[0]}" \
										"${node_l2.md5sum}" "${node_l2.filenames[0]}" \
										"${xlfd1}"
								fi
							done
						done
					done
				done
			done
		done
	done

	return 0
}

# main
builtin basename
builtin cat
builtin sum
builtin mkdir
builtin rm

typeset progname="$(basename "${0}")"

typeset -r reportfile="hashtree_20080604.cpv"

IFS=''

typeset data=()
typeset -A data.hashnodes

typeset mode="$1"
shift

case "$mode" in
	"hash")
		do_hash_fonts "$@"
		exit $?
		;;
	"xlfd_tree")
		do_xlfd_tree "leaf_hash" "raw_tree"
		exit $?
		;;
	"license_tree")
		do_xlfd_tree "leaf_license" "raw_tree"
		exit $?
		;;
	"license_flat")
		do_xlfd_tree "leaf_license" "flat"
		exit $?
		;;
	"license_html")
		do_xlfd_tree "leaf_license" "flat_html"
		exit $?
		;;
	"print_duplicate_files")
		do_print_duplicate_files "$@"
		exit $?
		;;
	"print_duplicate_xlfd")
		do_print_duplicate_xlfd "$@"
		exit $?
		;;
	"report")
		do_report "$@"
		exit $?
		;;
	*)
		print -u2 -f "ERROR: Unknown mode %s.\n" "$1"
		exit 1
		;;
esac


# EOF.

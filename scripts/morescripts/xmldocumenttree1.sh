#!/usr/bin/ksh93

########################################################################
#                                                                      #
#               This software is part of the ast package               #
#                 Copyright (c) 2006-2012 Roland Mainz                 #
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
# Copyright (c) 2006, 2013, Roland Mainz. All rights reserved.
#

# Solaris needs /usr/xpg6/bin:/usr/xpg4/bin because the tools in /usr/bin are not POSIX-conformant
export PATH='/usr/xpg6/bin:/usr/xpg4/bin:/bin:/usr/bin'

function fatal_error
{
	print -u2 -n "${progname}: "
	print -u2 -f "$@"
	exit 1
}

function attrstrtoattrarray
{
#set -o xtrace
    typeset s="$1"
    nameref aa=$2 # attribute array
    integer aa_count=0
    integer aa_count=0
    typeset nextattr
    integer currattrlen=0
    typeset tagstr
    typeset tagval

    while (( ${#s} > 0 )) ; do
        # skip whitespaces
        while [[ "${s:currattrlen:1}" == ~(E)[[:space:]] ]] ; do
            (( currattrlen++ ))
        done
        s="${s:currattrlen:${#s}}"
        
        # anything left ?
        (( ${#s} == 0 )) && break

        # Pattern tests:
        #x="foo=bar huz=123" ; print "${x##~(E)[[:alnum:]_\-:]*=[^[:blank:]\"]*}"
        #x='foo="ba=r o" huz=123' ; print "${x##~(E)[[:alnum:]_\-:]*=\"[^\"]*\"}"
        #x="foo='ba=r o' huz=123" ; print "${x##~(E)[[:alnum:]_\-:]*=\'[^\"]*\'}"
        #x="foox huz=123" ; print "${x##~(E)[[:alnum:]_\-:]*}"
        # All pattern combined via eregex (w|x|y|z):
        #x='foo="bar=o" huz=123' ; print "${x##~(E)([[:alnum:]_\-:]*=[^[:blank:]\"]*|[[:alnum:]_\-:]*=\"[^\"]*\"|[[:alnum:]_\-:]*=\'[^\"]*\')}"
        nextattr="${s##~(E)([[:alnum:]_\-:]*=[^[:blank:]\"]*|[[:alnum:]_\-:]*=\"[^\"]*\"|[[:alnum:]_\-:]*=\'[^\"]*\'|[[:alnum:]_\-:]*)}"
        (( currattrlen=${#s} - ${#nextattr}))

        # add entry
        tagstr="${s:0:currattrlen}"
        if [[ "${tagstr}" == *=* ]] ; then
            # normal case: attribute with value
            
            tagval="${tagstr#*=}"
            
            # strip quotes ('' or "")
            if [[ "${tagval}" == ~(Elr)(\'.*\'|\".*\") ]] ; then
                tagval="${tagval:1:${#tagval}-2}"
            fi
            
            aa[${aa_count}]=( name="${tagstr%%=*}" value="${tagval}" )
        else
            # special case for HTML where you have something like <foo baz>
            aa[${aa_count}]=( name="${tagstr}" )
        fi
        (( aa_count++ ))
        (( aa_count > 1000 )) && fatal_error "%s: aa_count too large\n" "$0" # assert
    done
}


function handle_document
{
#set -o xtrace
    nameref callbacks=${1}
    typeset tag_type="${2}"
    typeset tag_value="${3}"
    typeset tag_attributes="${4}"
    nameref doc=${callbacks["arg_tree"]}
    nameref nodepath="${stack.items[stack.pos]}"
    nameref nodesnum="${stack.items[stack.pos]}num"
    
    case "${tag_type}" in
        'tag_begin')
            nodepath[${nodesnum}]+=( 
                typeset tagtype='element'
                typeset tagname="${tag_value}"
                compound -A tagattributes
                compound -A nodes
                integer nodesnum=0
            )

            # fill attributes
            if [[ "${tag_attributes}" != '' ]] ; then
                attrstrtoattrarray "${tag_attributes}" "nodepath[${nodesnum}].tagattributes"
            fi
            
            (( stack.pos++ ))
            stack.items[stack.pos]="${stack.items[stack.pos-1]}[${nodesnum}].nodes"
            (( nodesnum++ ))
            ;;
        'tag_end')
            (( stack.pos-- ))
            ;;
        'tag_text')
            nodepath[${nodesnum}]+=( 
                typeset tagtype='text'
                typeset tagvalue="${tag_value}"
            )
            (( nodesnum++ ))
            ;;
        'tag_comment')
            nodepath[${nodesnum}]+=( 
                typeset tagtype='comment'
                typeset tagvalue="${tag_value}"
            )
            (( nodesnum++ ))
            ;;
        'document_start')
            ;;
        'document_end')
            ;;
    esac
    
#    print "xmltok: '${tag_type}' = '${tag_value}'"
}

function xml_tok
{
    typeset buf=''
    typeset namebuf=''
    typeset attrbuf=''
    typeset c=''
    bool isendtag	# bool: true/false
    bool issingletag	# bool: true/false (used for tags like "<br />")
    nameref callbacks=${1}
    
    [[ -v callbacks["document_start"] ]] && ${callbacks["document_start"]} "${1}" "document_start"

    while IFS='' read -r -N 1 c ; do
        isendtag=false
        
        if [[ "$c" == "<" ]] ; then
	    # flush any text content
            if [[ "$buf" != '' ]] ; then
                [[ -v callbacks["tag_text"] ]] && ${callbacks["tag_text"]} "${1}" "tag_text" "$buf"
                buf=''
            fi
            
            IFS='' read -r -N 1 c
            if [[ "$c" == '/' ]] ; then
                isendtag=true
            else
                buf="$c"
            fi
            IFS='' read -r -d '>' c
            buf+="$c"
	    
	    # handle comments
	    if [[ "$buf" == ~(El)!-- ]] ; then
	        # did we read the comment completely ?
	        if [[ "$buf" != ~(Elr)!--.*-- ]] ; then
		    buf+=">"
	            while [[ "$buf" != ~(Elr)!--.*-- ]] ; do
		        IFS='' read -r -N 1 c || break
		        buf+="$c"
		    done
		fi
	    
		[[ -v callbacks["tag_comment"] ]] && ${callbacks["tag_comment"]} "${1}" "tag_comment" "${buf:3:${#buf}-5}"
		buf=''
		continue
	    fi
	    
	    # check if the tag starts and ends at the same time (like "<br />")
	    if [[ "${buf}" == ~(Er).*/ ]] ; then
	        issingletag=true
		buf="${buf%*/}"
	    else
	        issingletag=false
	    fi
	    
	    # check if the tag has attributes (e.g. space after name)
	    if [[ "$buf" == ~(E)[[:space:]] ]] ; then
	        namebuf="${buf%%~(E)[[:space:]].*}"
                attrbuf="${buf#~(E).*[[:space:]]}"
            else
	        namebuf="$buf"
		attrbuf=''
	    fi
	    
            if (( isendtag )) ; then
                [[ -v callbacks["tag_end"] ]] && ${callbacks["tag_end"]} "${1}" "tag_end" "$namebuf"
            else
                [[ -v callbacks["tag_begin"] ]] && ${callbacks["tag_begin"]} "${1}" "tag_begin" "$namebuf" "$attrbuf"

                # handle tags like <br/> (which are start- and end-tag in one piece)
                if (( issingletag )) ; then
                    [[ -v callbacks["tag_end"] ]] && ${callbacks["tag_end"]} "${1}" "tag_end" "$namebuf"
                fi
            fi
            buf=''
        else
            buf+="$c"
        fi
    done

    [[ -v callbacks["document_end"] ]] && ${callbacks["document_end"]} "${1}" "document_end" "exit_success"
    
    print # final newline to make filters like "sed" happy
    return 0
}

function print_sample1_xml
{
cat <<EOF
<br />
<score-partwise instrument="flute1">
        <identification>
            <kaiman>nocrocodile</kaiman>
        </identification>
        <!-- a comment -->
        <partlist>
            <foo>myfootext</foo>
            <bar>mybartext</bar>
            <snap />
            <!-- another
                 comment -->
            <ttt>myttttext</ttt>
        </partlist>
</score-partwise>
EOF
}

function usage
{
    OPTIND=0
    getopts -a "${progname}" "${xmldocumenttree1_usage}" OPT '-?'
    exit 2
}

# program start
builtin basename
builtin cat
builtin date
builtin uname

typeset progname="${ basename "${0}" ; }"

typeset -r xmldocumenttree1_usage=$'+
[-?\n@(#)\$Id: xmldocumenttree1 (Roland Mainz) 2010-11-22 \$\n]
[-author?Roland Mainz <roland.mainz@nrubsig.org>]
[+NAME?xmldocumenttree1 - XML tree demo]
[+DESCRIPTION?\bxmldocumenttree\b is a small ksh93 compound variable demo
        which reads a XML input file, converts it into an internal
        variable tree representation and outputs it in the format
        specified by viewmode (either "list", "namelist", "tree" or "compacttree").]

file viewmode

[+SEE ALSO?\bksh93\b(1)]
'

while getopts -a "${progname}" "${xmldocumenttree1_usage}" OPT ; do 
	case "${OPT}" in
		*)    usage ;;
	esac
done
shift $(( OPTIND-1 ))

typeset xmlfile="$1"
typeset viewmode="$2"

if [[ "${xmlfile}" == '' ]] ; then
    fatal_error $"No file given.\n"
fi

if [[ "${viewmode}" != ~(Elr)(list|namelist|tree|compacttree) ]] ; then
    fatal_error $"Invalid view mode %q.\n" "${viewmode}"
fi

compound xdoc
compound -A xdoc.nodes
integer xdoc.nodesnum=0

compound stack
typeset -a stack.items=( [0]='doc.nodes' )
integer stack.pos=0

# setup callbacks for xml_tok
typeset -A document_cb # callbacks for xml_tok
document_cb["document_start"]="handle_document"
document_cb["document_end"]="handle_document"
document_cb["tag_begin"]="handle_document"
document_cb["tag_end"]="handle_document"
document_cb["tag_text"]="handle_document"
document_cb["tag_comment"]="handle_document"
# argument for "handle_document"
document_cb["arg_tree"]="xdoc"


if [[ "${xmlfile}" == '#sample1' ]] ; then
    print_sample1_xml | xml_tok document_cb
elif [[ "${xmlfile}" == '#sample2' ]] ; then
    /usr/sfw/bin/wget \
            --user-agent='ksh93_xmldocumenttree' \
	    --output-document=- \
	    'http://www.google.com/custom?q=gummi+bears' |
        /usr/bin/iconv -f 'ISO8859-1' |
        xml_tok document_cb
else
    cat "${xmlfile}" | xml_tok document_cb
fi

print -u2 "#parsing completed."

case "${viewmode}" in
    'list')
        set | egrep 'xdoc.*(tagname|tagtype|tagval|tagattributes)' | fgrep -v ']=$'
        ;;
    'namelist')
        typeset + | egrep 'xdoc.*(tagname|tagtype|tagval|tagattributes)'
        ;;
    'tree')
        print -v xdoc
        ;;
    'compacttree')
        print -C xdoc
        ;;
       *)
        fatal_error $"Invalid view mode %q.\n" "${viewmode}"
        ;;
esac

print -u2 '#done.'

exit 0
# EOF.

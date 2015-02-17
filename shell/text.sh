# Escape UTF-8 characters into their 3-byte format
escape() {
	printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u)
}

# Decode \x{ABCD}-style Unicode escape sequences
unidecode() {
	perl -e "binmode(STDOUT, ':utf8'); print \"$@\""
}

# Get a character's Unicode code point
codepoint() {
	perl -e "use utf8; print sprintf('U+%04X', ord(\"$@\"))"
}

# Create a data URL from a file
data_url() {
	local mimeType=$(file -b --mime-type "$1")
	if test $mimeType = text/*; then
		mimeType="${mimeType};charset=utf-8"
	fi
	echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}

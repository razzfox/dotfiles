# default word/field seperator: IFS:$' \t\n'

# getting path
IFS=: eval 'path=($PATH)'

# file lines
arrayFromFilename() {
  IFS=$'\n' read -ra $arrayName <$filename
}

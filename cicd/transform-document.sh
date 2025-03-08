#!/bin/sh

set -e

# Get app files directory
FILE=''
if [ $# -gt 0 ]; then
	FILE="$1"
	shift
fi
if [ ! -f "$FILE" ]; then
	echo "File '$FILE' does not exist"
	exit 1
fi

echo "Transforming file '$FILE'..."

# Replace '\[.....\]' or '.....' with long input line
sed -i 's/\\\[\.\{5\}\\\]\|\.\{5\}/<span class="input-line input-line-long"><\/span>/g' "$FILE"

# Replace '\[....\]' with two standard input lines
sed -i 's/\\\[\.\{4\}\\\]/<span class="input-line"><\/span><span class="input-line input-line-next"><\/span><span class="input-line input-line-next"><\/span><span class="input-line input-line-next"><\/span>/g' "$FILE"

# Replace '\[...\]' or '....' with standard input line
sed -i 's/\\\[\.\{3\}\\\]\|\.\{4\}/<span class="input-line"><\/span><span class="input-line input-line-next"><\/span>/g' "$FILE"

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

# Replace '.....' with long input line
sed -i 's|\.\{5\}|<span class="input-line input-line-long"></span>|g' "$FILE"

# Replace '....' with standard input line
sed -i 's|\.\{4\}|<span class="input-line"></span>|g' "$FILE"

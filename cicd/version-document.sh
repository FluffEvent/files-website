#!/bin/sh
set -e

# Get file
FILE=''
if [ $# -gt 0 ]; then
	FILE="$1"
	shift
fi
if [ ! -f "${FILE}" ]; then
	echo "File '${FILE}' does not exist"
	exit 1
fi

# Get version
VERSION=''
if [ $# -gt 0 ]; then
	VERSION="$1"
	shift
fi
if [ -z "${VERSION}" ]; then
	echo "Version is required"
	exit 1
fi

echo "Adding version '${VERSION}' to file '${FILE}'..."

# Check for existing front matter
if [ "$(head -n 1 "${FILE}")" = '---' ]; then

	# Get line number of closing front matter delimiter
	LINE=$(grep -m 2 -n '^---$' "${FILE}" | tail -n 1 | cut -d ':' -f 1)

	# Append version to front matter
	sed -i "5i\version: '${VERSION}'" "${FILE}"

else

	# Prepend new front matter with version
	sed -i "1i\---\nversion: '${VERSION}'\n---\n" "${FILE}"

fi

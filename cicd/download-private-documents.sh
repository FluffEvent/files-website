#!/bin/sh
set -e

# Get app files directory
DIR='./app/app'
if [ $# -gt 0 ]; then
	DIR="$1"
	shift
fi
if [ ! -d "$DIR" ]; then
	echo "Directory '$DIR' does not exist"
	exit 1
fi

REPO='FluffEvent/association-private-documents'
BASE_URL="https://raw.githubusercontent.com/$REPO/refs/heads/main"

# Download list of files to download
LIST_PATH='files-website-downloads.txt'
COMMIT_HASH=$(
	curl -fsSL "https://api.github.com/repos/$REPO/commits/main?path=$LIST_PATH" \
		-H "Authorization: Bearer $(gh auth token)" \
	| jq -r '.sha'
)
FILES=$(
	curl -fsSL "$BASE_URL/$LIST_PATH" \
		-H "Authorization: Bearer $(gh auth token)"
)

# Iterate over files
for FILE_INPUT in $FILES; do

	# Extract file path and destination
	IFS='|' read -r FILE_PATH FILE_DESTINATION <<-EOF
	$FILE_INPUT
	EOF

	echo "Downloading file '$FILE_DESTINATION'..."

	# Get the latest commit hash for the file
	COMMIT_HASH=$(
		curl -fsSL "https://api.github.com/repos/$REPO/commits/main?path=$FILE_PATH" \
			-H "Authorization: Bearer $(gh auth token)" \
		| jq -r '.sha'
	)

	# Download file
	curl -fsSL "$BASE_URL/$FILE_PATH" \
		-H "Authorization: Bearer $(gh auth token)" \
		-o "/tmp/$FILE_DESTINATION"

	# Add version to file
	"$(dirname "$0")/version-document.sh" "/tmp/$FILE_DESTINATION" "$COMMIT_HASH"

	# Transform file
	"$(dirname "$0")/transform-document.sh" "/tmp/$FILE_DESTINATION"

	# Copy file to destination
	mkdir -p "$DIR/src/content/private-documents"
	cp "/tmp/$FILE_DESTINATION" "$DIR/src/content/private-documents/$FILE_DESTINATION"
	rm "/tmp/$FILE_DESTINATION"

	echo 'Done. ---'

done

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


REPO='FluffEvent/association-documents'
BASE_URL="https://raw.githubusercontent.com/$REPO/refs/heads/main"

# List files to download
FILES=$(cat <<EOF
R%C3%A8glement%20Int%C3%A9rieur.md|reglement-interieur.md
Statuts.md|statuts.md
EOF
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
		| jq -r '.sha'
	)

	# Download file
	curl -fsSL "$BASE_URL/$FILE_PATH" \
		-o "/tmp/$FILE_DESTINATION"

	# Add version to file
	"$(dirname "$0")/version-document.sh" "/tmp/$FILE_DESTINATION" "$COMMIT_HASH"

	# Transform file
	"$(dirname "$0")/transform-document.sh" "/tmp/$FILE_DESTINATION"

	# Copy file to destination
	mkdir -p "$DIR/src/content/documents"
	cp "/tmp/$FILE_DESTINATION" "$DIR/src/content/documents/$FILE_DESTINATION"
	rm "/tmp/$FILE_DESTINATION"

	echo 'Done. ---'

done

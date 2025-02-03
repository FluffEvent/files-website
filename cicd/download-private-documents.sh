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


BASE_URL='https://raw.githubusercontent.com/FluffEvent/association-private-documents/refs/heads/main'

# List files to download
FILES=$(cat <<EOF
Contrats/Contrat%20cession%20droits%20auteur%20EN.md|contrat-cession-droits-auteur-en.md
Contrats/Contrat%20cession%20droits%20auteur%20FR.md|contrat-cession-droits-auteur-fr.md
EOF
)

# Iterate over files
for FILE_INPUT in $FILES; do

	# Extract file path and destination
	IFS='|' read -r FILE_PATH FILE_DESTINATION <<-EOF
	$FILE_INPUT
	EOF

	echo "Handling file '$FILE_DESTINATION'..."

	# Get the latest commit hash for the file
	COMMIT_HASH=$(
		curl -fsSL "https://api.github.com/repos/FluffEvent/association-private-documents/commits/main?path=$FILE_PATH" \
			-H "Authorization: Bearer $(gh auth token)" \
		| jq -r '.sha'
	)

	# Download file
	curl -fsSL "$BASE_URL/$FILE_PATH" \
		-H "Authorization: Bearer $(gh auth token)" \
		-o "/tmp/$FILE_DESTINATION"

	# Create destination file
	mkdir -p "$DIR/src/content/private-documents"
	touch "$DIR/src/content/private-documents/$FILE_DESTINATION"

	# Append front matter to destination file
	echo '---' > "$DIR/src/content/private-documents/$FILE_DESTINATION"
	echo 'version: "'"$COMMIT_HASH"'"' >> "$DIR/src/content/private-documents/$FILE_DESTINATION"
	echo '---' >> "$DIR/src/content/private-documents/$FILE_DESTINATION"

	# Append downloaded file content to destination file
	echo '' >> "$DIR/src/content/private-documents/$FILE_DESTINATION"
	cat "/tmp/$FILE_DESTINATION" >> "$DIR/src/content/private-documents/$FILE_DESTINATION"

	# Remove downloaded file
	rm "/tmp/$FILE_DESTINATION"

done

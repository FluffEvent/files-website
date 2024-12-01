#!/bin/sh

set -e

# Get app files directory
DIR='.'
if [ $# -gt 0 ]; then
	DIR="$1"
	shift
fi
if [ ! -d "$DIR" ]; then
	echo "Directory '$DIR' does not exist"
	exit 1
fi

# Download FluffEvent association documents
echo "Downloading FluffEvent association documents..."
BASE_URL='https://raw.githubusercontent.com/FluffEvent/association-documents/refs/heads/main'
curl -fsSL "$BASE_URL/R%C3%A8glement%20int%C3%A9rieur.md" \
	-o /tmp/reglement-interieur.md
curl -fsSL "$BASE_URL/Statuts.md" \
	-o /tmp/statuts.md

# Move documents in the application contents
echo "Moving documents to '$DIR/src/content/documents/'..."
mkdir -p "$DIR/src/content/documents"
mv /tmp/reglement-interieur.md "$DIR/src/content/documents/"
mv /tmp/statuts.md "$DIR/src/content/documents/"

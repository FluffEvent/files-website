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

# Get the commit hash for FluffEvent association documents
echo "Getting the commit hash for FluffEvent association documents..."
COMMIT_HASH=$(curl -fsSL 'https://api.github.com/repos/FluffEvent/association-documents/commits/main' | jq -r '.sha')

# Download FluffEvent association documents
echo "Downloading FluffEvent association documents..."
BASE_URL='https://raw.githubusercontent.com/FluffEvent/association-documents/refs/heads/main'
curl -fsSL "$BASE_URL/R%C3%A8glement%20Int%C3%A9rieur.md" \
	-o /tmp/reglement-interieur.content.md
curl -fsSL "$BASE_URL/Statuts.md" \
	-o /tmp/statuts.content.md

# Add front matter to documents
echo "Adding front matter to documents..."

echo '---' > /tmp/reglement-interieur.md
echo 'version: "'"$COMMIT_HASH"'"' >> /tmp/reglement-interieur.md
echo '---' >> /tmp/reglement-interieur.md
echo '' >> /tmp/reglement-interieur.md
cat /tmp/reglement-interieur.content.md >> /tmp/reglement-interieur.md
rm /tmp/reglement-interieur.content.md

echo '---' > /tmp/statuts.md
echo 'version: "'"$COMMIT_HASH"'"' >> /tmp/statuts.md
echo '---' >> /tmp/statuts.md
echo '' >> /tmp/statuts.md
cat /tmp/statuts.content.md >> /tmp/statuts.md
rm /tmp/statuts.content.md

# Move documents in the application contents
echo "Moving documents to '$DIR/src/content/documents/'..."
mkdir -p "$DIR/src/content/documents"
mv /tmp/reglement-interieur.md "$DIR/src/content/documents/"
mv /tmp/statuts.md "$DIR/src/content/documents/"

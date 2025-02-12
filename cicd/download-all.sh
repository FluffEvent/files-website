#!/bin/sh
set -e

"$(dirname "$0")/download-documents.sh" "$@"
"$(dirname "$0")/download-private-documents.sh" "$@"

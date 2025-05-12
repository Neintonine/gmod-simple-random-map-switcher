#!/bin/env sh

set -e

# build path
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
ADDON_DIR="$SCRIPT_DIR/.."
BIN_DIR="$ADDON_DIR/../../../bin"
ADDON_FILE="$SCRIPT_DIR/addon.gma"

echo "Creating addon..."
echo " - from: $ADDON_DIR"

echo " => Creating gma-file using gmad..."
"${BIN_DIR}/gmad_linux" create -folder "$ADDON_DIR" -out "$ADDON_FILE"

echo " => Uploading..."
"${BIN_DIR}/gmpublish_linux" create -addon "$ADDON_FILE" -icon "$SCRIPT_DIR/addon-icon.jpeg"

echo " => Cleanup"
rm "$ADDON_FILE"

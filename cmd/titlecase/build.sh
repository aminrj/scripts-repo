#!/usr/bin/env bash
set -e

# Where you want to place the final binary:
INSTALL_DIR="$HOME/scripts"
# Name of the binary:
BINARY_NAME="titlecase"

# Ensure the install directory exists
mkdir -p "$INSTALL_DIR"

echo "=== Building and installing $BINARY_NAME ==="

# 1. Sync (or install) any Go dependencies
go mod tidy

# 2. Build the script
go build -o "${INSTALL_DIR}/${BINARY_NAME}" .

# Optionally, show final path and version
echo "Installed ${BINARY_NAME} to ${INSTALL_DIR}/${BINARY_NAME}"
echo "Go module info:"
go version
go list -m all | grep 'golang.org/x/text\|example.com/titlecase' || true

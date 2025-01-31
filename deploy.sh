#!/usr/bin/env bash
set -e

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIST_DIR="${BASE_DIR}/dist"
LOCAL_SCRIPTS="$HOME/scripts"

echo "=== Deploying compiled binaries to $LOCAL_SCRIPTS ==="
mkdir -p "$LOCAL_SCRIPTS"

# Copy only the current OS/ARCH if you prefer, or pick the relevant subfolder
# Let's assume we're on a machine with GOOS=linux, GOARCH=amd64
GOOS=${GOOS:-$(go env GOOS 2>/dev/null || echo "linux")}
GOARCH=${GOARCH:-$(go env GOARCH 2>/dev/null || echo "amd64")}

# For each tool in dist, copy the OS/ARCH binary
for tool_dir in "$DIST_DIR"/*; do
  [ -d "$tool_dir" ] || continue
  tool_name="$(basename "$tool_dir")"

  # If it's a Go tool, it has subdirectories like dist/go-tool/linux/amd64/go-tool
  # If it's Python/PyInstaller, we may store it directly in dist/python-tool/...
  # So let's do a quick check:
  if [ -d "$tool_dir/$GOOS/$GOARCH" ]; then
    # For Go
    src_bin="$tool_dir/$GOOS/$GOARCH/$tool_name"
    if [ -x "$src_bin" ]; then
      cp "$src_bin" "$LOCAL_SCRIPTS/"
      echo "Deployed $tool_name -> $LOCAL_SCRIPTS/$tool_name"
    fi
  else
    # Possibly a Python binary or something else
    # We'll check for a single file named $tool_name in dist/<tool_name>
    if [ -f "$tool_dir/$tool_name" ]; then
      cp "$tool_dir/$tool_name" "$LOCAL_SCRIPTS/"
      echo "Deployed $tool_name -> $LOCAL_SCRIPTS/$tool_name"
    fi
  fi
done

echo "=== Deployment complete! ==="
echo "Make sure $LOCAL_SCRIPTS is on your PATH."

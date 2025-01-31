#!/usr/bin/env bash
set -e

# Adjust these lists if you want to build for more/less OS/Architectures
OS_LIST="linux windows darwin"
ARCH_LIST="amd64 arm64"

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CMD_DIR="${BASE_DIR}/cmd"
DIST_DIR="${BASE_DIR}/dist"

# Ensure dist directory exists
mkdir -p "$DIST_DIR"

echo "=== Building tools from $CMD_DIR into $DIST_DIR ==="

# Iterate over each subdirectory in cmd/
for tool_dir in "$CMD_DIR"/*; do
  # Only proceed if it's a directory
  [ -d "$tool_dir" ] || continue

  tool_name="$(basename "$tool_dir")"

  # Each tool_dir is expected to have a build.conf with "LANGUAGE=go" or "LANGUAGE=python"
  if [ -f "${tool_dir}/build.conf" ]; then
    # Source the config (read environment variables from it)
    . "${tool_dir}/build.conf"
  else
    echo "No build.conf found in $tool_dir — skipping..."
    continue
  fi

  echo ""
  echo "=== Building $tool_name (LANGUAGE=$LANGUAGE) ==="

  # Dispatch build logic based on the LANGUAGE var
  case "$LANGUAGE" in
  go)
    # Build for multiple OS/Arch combos
    for os in $OS_LIST; do
      for arch in $ARCH_LIST; do
        out_dir="${DIST_DIR}/${tool_name}/${os}/${arch}"
        mkdir -p "$out_dir"
        echo " -> GOOS=$os GOARCH=$arch go build -o ${out_dir}/${tool_name}"
        GOOS=$os GOARCH=$arch go build -o "${out_dir}/${tool_name}" "$tool_dir"
      done
    done
    ;;
  python)
    # Example: build a single-file binary for the current OS using PyInstaller
    # True cross-compilation for Python is more complex and typically requires
    # building on each target OS or using specialized Docker images.
    if ! command -v pyinstaller &>/dev/null; then
      echo "PyInstaller not found, skipping Python build for $tool_name"
      continue
    fi
    out_dir="${DIST_DIR}/${tool_name}"
    mkdir -p "$out_dir"

    # Basic PyInstaller command
    echo " -> pyinstaller --onefile --distpath $out_dir ${tool_dir}/main.py"
    pyinstaller --onefile --distpath "$out_dir" "${tool_dir}/main.py" \
      --name "$tool_name"

    # PyInstaller by default puts extra files in a "build" folder
    # You may want to remove or ignore it
    rm -rf build
    ;;
  *)
    echo "Unknown or unsupported LANGUAGE=$LANGUAGE for $tool_name, skipping..."
    ;;
  esac
done

echo ""
echo "=== Build complete! Artifacts are in $DIST_DIR ==="

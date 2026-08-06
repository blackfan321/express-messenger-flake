nix_file := "express.nix"

set quiet := true
set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

pull_appimage version:
  wget2 --force-progress -O "eXpress-{{version}}.AppImage" \
    "https://updates.express.ms/desktop/eXpress-{{version}}.AppImage" >&2

  nix hash file "eXpress-{{version}}.AppImage"

get_latest_appimage_version:
  { wget2 --server-response --max-redirect=0 --spider "https://express.ms/download/appimage" 2>&1 || true; } \
    | rg -o 'eXpress-([0-9]+\.[0-9]+\.[0-9]+)\.AppImage' -r '$1' \
    | head -n1

pull_latest_appimage:
  just pull_appimage "$(just get_latest_appimage_version)"

update_application:
  #!/usr/bin/env bash
  set -euo pipefail

  OLD_VERSION="$(rg -m1 -o 'version = "[^"]+"' "{{nix_file}}" | sed 's/version = "\(.*\)"/\1/')"
  NEW_VERSION="$(just get_latest_appimage_version)"

  if [[ "$OLD_VERSION" == "$NEW_VERSION" ]]; then
    echo "Already up to date: $NEW_VERSION"
    exit 0
  fi

  HASH="$(just pull_appimage "$NEW_VERSION" | tail -n1)"

  sed -i \
    -e 's/version = "[^"]*"/version = "'"$NEW_VERSION"'"/' \
    -e 's|hash = "[^"]*"|hash = "'"$HASH"'"|' \
    {{nix_file}}

  just cleanup
  echo "Updated: $OLD_VERSION -> $NEW_VERSION"

cleanup:
  rm -f -- *.AppImage

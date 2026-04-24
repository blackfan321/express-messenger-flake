pull_appimage version:
  wget -O "eXpress-{{version}}.AppImage" "https://updates.express.ms/desktop/eXpress-{{version}}.AppImage"
  nix hash file "eXpress-{{version}}.AppImage"

cleanup:
  rm *.AppImage

#!/usr/bin/env bash
set -euo pipefail

RENOISE_VERSION=3.5.4
EXTRACT_DIR=/tmp/Renoise_${RENOISE_VERSION}_Demo_Linux_x86_64

curl -L -o /tmp/renoise.tar.gz "https://files.renoise.com/demo/Renoise_3_5_4_Demo_Linux_x86_64.tar.gz"
tar xf /tmp/renoise.tar.gz -C /tmp

# Skip install.sh — it targets /usr/local which symlinks to /var/usrlocal on immutable OS
# and is not included in the deployed ostree image.
# Instead, install directly into /usr paths.

# Keep binary and Resources/ together so Renoise can find its resources via relative path
mkdir -p /usr/lib/renoise
cp -r "${EXTRACT_DIR}/Resources" /usr/lib/renoise/
install -m755 "${EXTRACT_DIR}/renoise" /usr/lib/renoise/renoise

# Wrapper script so 'renoise' is in PATH and the binary runs from its own directory
cat > /usr/bin/renoise << 'EOF'
#!/bin/bash
exec /usr/lib/renoise/renoise "$@"
EOF
chmod 755 /usr/bin/renoise

# Desktop entry, icons, MIME types, man pages
install -D -m644 "${EXTRACT_DIR}/Installer/renoise.desktop" \
  /usr/share/applications/renoise.desktop
install -D -m644 "${EXTRACT_DIR}/Installer/renoise-48.png" \
  /usr/share/icons/hicolor/48x48/apps/renoise.png
install -D -m644 "${EXTRACT_DIR}/Installer/renoise-64.png" \
  /usr/share/icons/hicolor/64x64/apps/renoise.png
install -D -m644 "${EXTRACT_DIR}/Installer/renoise-128.png" \
  /usr/share/icons/hicolor/128x128/apps/renoise.png
install -D -m644 "${EXTRACT_DIR}/Installer/renoise.xml" \
  /usr/share/mime/packages/renoise.xml
install -D -m644 "${EXTRACT_DIR}/Installer/renoise.1.gz" \
  /usr/share/man/man1/renoise.1.gz
install -D -m644 "${EXTRACT_DIR}/Installer/renoise-pattern-effects.5.gz" \
  /usr/share/man/man5/renoise-pattern-effects.5.gz

rm -rf /tmp/renoise.tar.gz "${EXTRACT_DIR}"

exit 0

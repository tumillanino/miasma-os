#!/usr/bin/env bash
set -euo pipefail

echo "Installing Bitwig Studio..."

dnf install -y libbsd bzip2-libs dpkg

curl -L -o /tmp/bitwig.deb "https://www.bitwig.com/dl/?id=419&os=installer_linux"

# Extract to temp dir to avoid /opt -> /var/opt symlink issues on immutable OS
mkdir -p /tmp/bitwig-extract
dpkg-deb -x /tmp/bitwig.deb /tmp/bitwig-extract

# Install main app to /usr/lib instead of /opt (which resolves to /var/opt at runtime)
mv /tmp/bitwig-extract/opt/bitwig-studio /usr/lib/bitwig-studio

# Copy remaining files (desktop entry, icons, mime types, etc.)
cp -rT /tmp/bitwig-extract/usr /usr

# Fix symlink to point to the new location
ln -sf /usr/lib/bitwig-studio/bitwig-studio /usr/bin/bitwig-studio

# Fix paths in .desktop file
if [ -f /usr/share/applications/com.bitwig.BitwigStudio.desktop ]; then
  sed -i 's|/opt/bitwig-studio|/usr/lib/bitwig-studio|g' /usr/share/applications/com.bitwig.BitwigStudio.desktop
fi

ln -sf /usr/lib64/libbz2.so.1 /usr/lib64/libbz2.so.1.0

rm -rf /tmp/bitwig-extract /tmp/bitwig.deb

echo "Bitwig Studio installation complete."

exit 0

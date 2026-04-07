#!/usr/bin/env bash
set -euo pipefail

echo "Installing Bitwig Studio..."

dnf install -y libbsd bzip2-libs dpkg

curl -L -o /tmp/bitwig.deb "https://www.bitwig.com/dl/?id=419&os=installer_linux"

dpkg-deb -x /tmp/bitwig.deb /

ln -sf /usr/lib64/libbz2.so.1 /usr/lib64/libbz2.so.1.0

rm -f /tmp/bitwig.deb

echo "Bitwig Studio installation complete."

exit 0

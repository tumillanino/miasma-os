#!/usr/bin/env bash

set -oue pipefail

# Fix boot entry title and OS identity
sed -i 's|^PRETTY_NAME=.*|PRETTY_NAME="Miasma OS"|' /usr/lib/os-release
sed -i 's|^NAME=.*|NAME="Miasma OS"|' /usr/lib/os-release
sed -i 's|^ID=.*|ID=miasma-os|' /usr/lib/os-release
sed -i 's|^ID_LIKE=.*|ID_LIKE=fedora|' /usr/lib/os-release
sed -i 's|^LOGO=.*|LOGO=distributor-logo|' /usr/lib/os-release

mv /tmp/files/assets/images/distributor-logo.svg /usr/share/icons/hicolor/scalable/places/distributor-logo.svg
mv /tmp/files/assets/splash/default.jxl /usr/share/backgrounds/default.jxl
mv /tmp/files/assets/splash/default-dark.jxl /usr/share/backgrounds/default-dark.jxl
mv /tmp/files/assets/images/watermark.png /usr/share/plymouth/themes/spinner/watermark.png
# Remove Bazzite animation/throbber frames so Plymouth uses only our watermark
rm -f /usr/share/plymouth/themes/spinner/animation-*.png
rm -f /usr/share/plymouth/themes/spinner/throbber-*.png
mv /tmp/files/assets/images/fedora-gdm-logo.png /usr/share/pixmaps/fedora-gdm-logo.png
mv /tmp/files/assets/images/fedora-logo-small.png /usr/share/pixmaps/fedora-logo-small.png
mv /tmp/files/assets/images/fedora-logo-sprite.png /usr/share/pixmaps/fedora-logo-sprite.png
mv /tmp/files/assets/images/fedora-logo-sprite.svg /usr/share/pixmaps/fedora-logo-sprite.svg
mv /tmp/files/assets/images/fedora-logo.png /usr/share/pixmaps/fedora-logo.png
mv /tmp/files/assets/images/fedora_logo_med.png /usr/share/pixmaps/fedora_logo_med.png
mv /tmp/files/assets/images/fedora_whitelogo.svg /usr/share/pixmaps/fedora_whitelogo.svg
mv /tmp/files/assets/images/fedora_whitelogo_med.png /usr/share/pixmaps/fedora_whitelogo_med.png
mv /tmp/files/assets/images/system-logo-white.png /usr/share/pixmaps/system-logo-white.png

# Replace EFI boot picker icon (shown before SDDM) with Miasma OS logo
mkdir -p /usr/share/pixmaps/bootloader
python3 -c "
import struct
with open('/usr/share/pixmaps/system-logo-white.png', 'rb') as f:
    png_data = f.read()
# ICNS format: embed PNG data directly using ic09 (512x512) slot
entry = b'ic09' + struct.pack('>I', 8 + len(png_data)) + png_data
icns = b'icns' + struct.pack('>I', 8 + len(entry)) + entry
with open('/usr/share/pixmaps/bootloader/fedora.icns', 'wb') as f:
    f.write(icns)
"

#!/usr/bin/env bash

set -oue pipefail
mv /tmp/files/assets/images/distributor-logo.svg /usr/share/icons/hicolor/scalable/places/distributor-logo.svg
mv /tmp/files/assets/splash/default.jxl /usr/share/backgrounds/default.jxl
mv /tmp/files/assets/splash/default-dark.jxl /usr/share/backgrounds/default-dark.jxl
mv /tmp/files/assets/images/watermark.png /usr/share/plymouth/themes/spinner/watermark.png

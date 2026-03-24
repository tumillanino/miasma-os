#!/usr/bin/env bash
set -euo pipefail

curl -L -o /tmp/reaper.tar.xz "https://www.reaper.fm/files/7.x/reaper765_linux_x86_64.tar.xz"
tar -xJf /tmp/reaper.tar.xz -C /tmp

cd /tmp/reaper_linux_x86_64
./install-reaper.sh --install /usr/lib --integrate-desktop

if [ -f "/root/.local/share/applications/cockos-reaper.desktop" ]; then
  mkdir -p /usr/share/applications/
  mv /root/.local/share/applications/cockos-reaper.desktop /usr/share/applications/
  sed -i 's|/root/opt/REAPER|/usr/lib/REAPER|g' /usr/share/applications/cockos-reaper.desktop
fi

rm -rf /tmp/reaper*

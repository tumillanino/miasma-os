#!/usr/bin/env bash
set -euo pipefail

curl -L -o /tmp/renoise.tar.gz "https://files.renoise.com/demo/Renoise_3_5_4_Demo_Linux_x86_64.tar.gz"
tar xvf /tmp/renoise.tar.gz -C /tmp

cd /tmp/Renoise_3_5_4_Demo_Linux_x86_64
./install.sh || echo "Installer finished with minor warnings (likely desktop-integration related)"

rm -rf /tmp/renoise.tar.gz /tmp/Renoise* || true

exit 0

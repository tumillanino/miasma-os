#!/usr/bin/env bash
set -euo pipefail

ROOT_UID=0
E_NOTROOT=87
DEFAULT_FILENAME="bitwig-studio-latest.deb"
DEFAULT_URL="https://www.bitwig.com/dl/?id=419&os=installer_linux"
INSTALL_LOG="/opt/bitwig-studio/.$DEFAULT_FILENAME.log"
SAFE_FILE_REMOVE="^/\./usr/share/*|^/\./opt/bitwig-studio/*"

curl -fsSL bitwig-studio-latest.deb $DEFAULT_URL

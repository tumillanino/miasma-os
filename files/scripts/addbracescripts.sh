#!/usr/bin/env bash

set -oue pipefail

./install-divested.sh 20250714
./install-divested.sh https://divested.dev/rpm/fedora/divested-release-20250714-1.noarch.rpm
BASE_URL='https://divested.dev/rpm/fedora'
PKG_PREFIX='divested-release'
ARCH='noarch'
RPM_SUFFIX='-1' # adjust if upstream uses a different release number
RETRY_OPTS=(--retry 3 --retry-delay 5 -S -L -O)

if [ "${#}" -eq 0 ]; then
  echo "Usage: $0 YYYYMMDD | FULL_RPM_URL" >&2
  exit 2
fi

INPUT="$1"

case "$INPUT" in
http:// | https://)
  RPM_URL="$INPUT"
  ;;
[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9])
  RELEASE_VERSION="$INPUT"
  FILENAME="${PKG_PREFIX}-${RELEASE_VERSION}${RPM_SUFFIX}.${ARCH}.rpm"
  RPM_URL="${BASE_URL}/${FILENAME}"
  ;;
*)
  echo "Invalid argument. Provide a date (YYYYMMDD) or a full URL." >&2
  exit 1
  ;;
esac

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

RPM_PATH="${TMPDIR}/$(basename "$RPM_URL")"

echo "Downloading ${RPM_URL} ..."
if command -v curl >/dev/null 2>&1; then
  curl "${RETRY_OPTS[@]}" -o "$RPM_PATH" "$RPM_URL"
elif command -v wget >/dev/null 2>&1; then
  wget --tries=3 --wait=5 -O "$RPM_PATH" "$RPM_URL"
else
  echo "Neither curl nor wget available." >&2
  exit 1
fi

echo "Installing ${RPM_PATH} ..."
sudo dnf install -y "$RPM_PATH"

echo "Installed $(basename "$RPM_PATH")"

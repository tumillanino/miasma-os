#!/usr/bin/env bash
# Replaces the stock Fedora kernel with the CachyOS LTO kernel.
# CachyOS LTO kernel is compiled with Link-Time Optimization and ships
# sched-ext (SCX) support, giving lower latency for realtime audio workloads.
#
# Adapted from the Zena project (https://github.com/zena-linux/zena),
# specifically build-scripts/modules/base/kernel.sh.
# Zena is licensed under the Apache License 2.0.
# Credit to the Zena contributors: https://github.com/zena-linux/zena/graphs/contributors

set -ouex pipefail

shopt -s nullglob

KERNEL_PACKAGES=(
  kernel-cachyos-lto
  kernel-cachyos-lto-core
  kernel-cachyos-lto-devel-matched
  kernel-cachyos-lto-modules
)

pushd /usr/lib/kernel/install.d
printf '%s\n' '#!/bin/sh' 'exit 0' >05-rpmostree.install
printf '%s\n' '#!/bin/sh' 'exit 0' >50-dracut.install
chmod +x 05-rpmostree.install 50-dracut.install
popd

for pkg in kernel kernel-core kernel-modules kernel-modules-core; do
  rpm --erase "$pkg" --nodeps || true
done

CURRENT_MODULES=$(ls /usr/lib/modules | head -n1)
if [ -n "$CURRENT_MODULES" ]; then
  rm -rf "/usr/lib/modules/$CURRENT_MODULES"
fi

dnf5 -y install "${KERNEL_PACKAGES[@]}"

dnf5 versionlock add "${KERNEL_PACKAGES[@]}" || true

rm -rf /boot/*

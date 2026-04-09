#!/usr/bin/env bash
# Replaces the stock Fedora kernel with the Bazzite kernel.
# The Bazzite kernel ships sched-ext (SCX) support and gaming/realtime
# optimizations, making it well-suited for low-latency audio workloads.
#
# Based on the solarpowered project kernel install approach:
# https://github.com/solar-powered/solarpowered

set -ouex pipefail

OS_VERSION=$(rpm -E %fedora)
VER=$(basename $(curl -Ls -o /dev/null -w %{url_effective} https://github.com/bazzite-org/kernel-bazzite/releases/latest))

# Disable kernel-install hooks so they don't trigger inside the container
# build environment. The initramfs will be generated explicitly below.
pushd /usr/lib/kernel/install.d
printf '%s\n' '#!/bin/sh' 'exit 0' >05-rpmostree.install
printf '%s\n' '#!/bin/sh' 'exit 0' >50-dracut.install
chmod +x 05-rpmostree.install 50-dracut.install
popd

# Erase stock Fedora kernel RPMs from the package database
for pkg in kernel kernel-core kernel-modules kernel-modules-core; do
  rpm --erase "$pkg" --nodeps || true
done

# Remove ALL existing kernel module directories.
for KVER in $(ls /usr/lib/modules 2>/dev/null); do
  rm -rf "/usr/lib/modules/$KVER"
done

# Create /boot/grub2 so grub2 RPM scriptlets don't fail in the container
# build environment. It gets removed by the rm -rf /boot/* below.
mkdir -p /boot/grub2

echo 'Installing Bazzite kernel...'
dnf install -y \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$VER/kernel-$VER.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$VER/kernel-common-$VER.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$VER/kernel-core-$VER.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$VER/kernel-devel-$VER.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$VER/kernel-devel-matched-$VER.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$VER/kernel-modules-$VER.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$VER/kernel-modules-akmods-$VER.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$VER/kernel-modules-core-$VER.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$VER/kernel-modules-extra-$VER.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$VER/kernel-modules-extra-matched-$VER.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$VER/kernel-modules-internal-$VER.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$VER/kernel-tools-$VER.fc$OS_VERSION.x86_64.rpm \
    https://github.com/bazzite-org/kernel-bazzite/releases/download/$VER/kernel-tools-libs-$VER.fc$OS_VERSION.x86_64.rpm

# Identify the newly installed Bazzite kernel version
NEW_KVER=$(ls /usr/lib/modules | head -n1)

# Ensure vmlinuz is at the path expected by rpm-ostree and bootc for boot
# entry generation.
if [ ! -f "/usr/lib/modules/${NEW_KVER}/vmlinuz" ]; then
  if [ -f "/boot/vmlinuz-${NEW_KVER}" ]; then
    cp "/boot/vmlinuz-${NEW_KVER}" "/usr/lib/modules/${NEW_KVER}/vmlinuz"
  else
    echo "ERROR: vmlinuz not found for kernel ${NEW_KVER}" >&2
    exit 1
  fi
fi

# Rebuild kernel module dependency map before generating initramfs.
depmod -a "${NEW_KVER}"

# Generate the initramfs inside the container image so that rpm-ostree and
# bootc can use it directly at deploy time.
dracut \
  --reproducible \
  --no-hostonly \
  --add "ostree" \
  --filesystems "btrfs" \
  --add-drivers "btrfs" \
  --force \
  "/usr/lib/modules/${NEW_KVER}/initramfs.img" \
  "${NEW_KVER}"

# Atomic images manage /boot via the bootloader layer; clear any kernel
# files the RPM dropped there.
rm -rf /boot/*

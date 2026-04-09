#!/usr/bin/env bash
# Replaces the stock Fedora kernel with the Bazzite kernel.
# The Bazzite kernel ships sched-ext (SCX) support and gaming/realtime
# optimizations, making it well-suited for low-latency audio workloads.
#
# Based on the solarpowered project kernel install approach:
# https://github.com/solar-powered/solarpowered

set -ouex pipefail

OS_VERSION=$(rpm -E %fedora)
VER=$(basename "$(curl -Ls -o /dev/null -w '%{url_effective}' https://github.com/bazzite-org/kernel-bazzite/releases/latest)")

# Verify we got a valid version string
if [[ -z "$VER" ]]; then
    echo "ERROR: Failed to determine latest bazzite kernel version" >&2
    exit 1
fi
echo "Bazzite kernel version: ${VER}"

# Disable kernel-install hooks so they don't trigger inside the container
# build environment. The initramfs will be generated explicitly below.
mkdir -p /usr/lib/kernel/install.d
pushd /usr/lib/kernel/install.d
printf '%s\n' '#!/bin/sh' 'exit 0' >05-rpmostree.install
printf '%s\n' '#!/bin/sh' 'exit 0' >50-dracut.install
chmod +x 05-rpmostree.install 50-dracut.install
popd

# Erase stock Fedora kernel RPMs from the package database (matches Bazzite's approach)
for pkg in kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra kernel-tools-libs kernel-tools; do
  rpm --erase "$pkg" --nodeps || true
done

# Remove ALL existing kernel module directories.
rm -rf /usr/lib/modules

# Create /boot/grub2 so grub2 RPM scriptlets don't fail in the container
# build environment. It gets removed by the rm -rf /boot/* below.
mkdir -p /boot/grub2

echo "Installing Bazzite kernel ${VER}..."
dnf5 install -y \
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
  --no-hostonly \
  --kver "${NEW_KVER}" \
  --reproducible \
  --zstd \
  -v \
  --add ostree \
  --force \
  "/usr/lib/modules/${NEW_KVER}/initramfs.img"

# Atomic images manage /boot via the bootloader layer; clear any kernel
# files the RPM dropped there.
rm -rf /boot/*

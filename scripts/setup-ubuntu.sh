#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run this script with sudo: sudo $0" >&2
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y \
  binutils-riscv64-linux-gnu \
  gcc-riscv64-linux-gnu \
  gdb-multiarch \
  git \
  make \
  python3 \
  python-is-python3 \
  qemu-system-misc

echo
qemu-system-riscv64 --version | head -n 1
riscv64-linux-gnu-gcc --version | head -n 1
echo "xv6 toolchain installation complete."

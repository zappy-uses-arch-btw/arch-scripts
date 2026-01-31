#!/usr/bin/env bash
set -e

echo "== Arch Gaming Optimization Script =="

# Must be run as root
if [[ $EUID -ne 0 ]]; then
  echo "Run this script as root (sudo)"
  exit 1
fi

echo "[1/9] Installing required tools..."
pacman -S --needed --noconfirm \
  cpupower irqbalance pciutils mesa-utils vulkan-tools

echo "[2/9] Enabling CPU performance governor..."
systemctl enable --now cpupower.service
cpupower frequency-set -g performance || true

echo "[3/9] Enabling IRQ balance..."
systemctl enable --now irqbalance.service

echo "[4/9] Creating 4G swapfile (if not exists)..."
if [[ ! -f /swapfile ]]; then
  fallocate -l 4G /swapfile || dd if=/dev/zero of=/swapfile bs=1M count=4096
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo "/swapfile none swap defaults 0 0" >> /etc/fstab
else
  echo "Swapfile already exists, skipping"
fi

echo "[5/9] Applying sysctl gaming tweaks..."
cat >/etc/sysctl.d/99-gaming.conf <<EOF
vm.swappiness=10
vm.vfs_cache_pressure=50
vm.dirty_ratio=20
vm.dirty_background_ratio=10
kernel.sched_autogroup_enabled=0
kernel.printk=3 3 3 3
EOF

sysctl --system

echo "[6/9] Setting HDD I/O scheduler (mq-deadline)..."
mkdir -p /etc/udev/rules.d
cat >/etc/udev/rules.d/60-ioscheduler.rules <<EOF
ACTION=="add|change", KERNEL=="sda", ATTR{queue/scheduler}="mq-deadline"
EOF

# Apply immediately if possible
if [[ -e /sys/block/sda/queue/scheduler ]]; then
  echo mq-deadline > /sys/block/sda/queue/scheduler || true
fi

echo "[7/9] Disabling unnecessary services..."
systemctl disable bluetooth.service cups.service avahi-daemon.service 2>/dev/null || true
systemctl disable NetworkManager-wait-online.service systemd-networkd-wait-online.service 2>/dev/null || true

echo "[8/9] Verifying AMD GPU driver..."
lsmod | grep -q amdgpu && echo "AMDGPU loaded ✔" || echo "AMDGPU not loaded (check manually)"

echo "[9/9] Done."
echo "Reboot recommended."

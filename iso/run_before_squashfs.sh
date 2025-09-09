#!/usr/bin/env bash

# ArchimedeOS Pre-SquashFS Initialization Script
# 
# This script runs during ISO construction, right before creating the squashfs filesystem.
# It performs ArchimedeOS-specific initialization tasks including GPG key setup,
# locale configuration, and system customization.
#
# Part of the ArchimedeOS ISO build process
# https://archimedeos.org

script_path=$(readlink -f "${0%/*}")
work_dir="work"

# Function to execute commands in the build chroot environment
arch_chroot() {
    # Path calculation: mkarchiso runs from scripts/, but this script is in iso/
    # So we need to go up one level then into scripts/work/
    chroot_path="${script_path}/../scripts/${work_dir}/x86_64/airootfs"
    arch-chroot "$chroot_path" /bin/bash -c "${1}"
}

do_merge() {

arch_chroot "$(cat << EOF

echo "==============================================="
echo "#        ArchimedeOS Live System Setup        #"
echo "==============================================="

cd "/root"

# GPG Key Initialization for ArchimedeOS
echo "==> Initializing GPG keys for ArchimedeOS..."
pacman-key --init
pacman-key --populate archlinux archimedeos chaotic
echo "==> Rafraîchissement des bases de données..."
pacman -Syy

# Locale Configuration
echo "==> Configuring system locales..."
sed -i 's/#\(en_US\.UTF-8\)/\1/' "/etc/locale.gen"
sed -i 's/#\(fr_FR\.UTF-8\)/\1/' "/etc/locale.gen"
locale-gen
ln -sf "/usr/share/zoneinfo/UTC" "/etc/localtime"

# Root User Configuration
echo "==> Configuring root user..."
usermod -s /usr/bin/bash root

# ArchimedeOS Build Information
echo "==> Adding ArchimedeOS build information..."
echo "------------------" >> "/etc/motd"
echo "ArchimedeOS Live - Built on \$(date)" >> "/etc/motd"
echo "https://archimedeos.org" >> "/etc/motd"
echo "------------------" >> "/etc/motd"

# SystemD Target Configuration
echo "==> Setting default systemd target to graphical..."
systemctl set-default graphical.target

# System Cleanup
echo "==> Cleaning up build artifacts..."
rm -f "/var/log/pacman.log"
rm -rf "/var/cache/pacman/pkg/"*

echo "==============================================="
echo "#     ArchimedeOS Setup Complete!            #"
echo "==============================================="

EOF
)"
}

#################################
########## STARTS HERE ##########
#################################

echo "ArchimedeOS: Starting pre-squashfs initialization..."
do_merge
echo "ArchimedeOS: Pre-squashfs setup completed successfully!"

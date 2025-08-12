#!/bin/bash

confirm() {
    read -rp "$1? (y/n): " choice
    case "$choice" in
        y|Y ) return 0 ;;
        * ) return 1 ;;
    esac
}

pause() {
    read -rp $'\n> Press Enter to continue...'
    echo
}

echo "> Post-Install Setup"
echo "------------------------------"
echo "1 - Setups in Chroot"
echo "2 - Installations after Reboot"
read -rp "Choose Stage: " stage
echo

# STAGE 1
# ---------------------
if [[ "$stage" == "1" ]]; then
    echo "> Stage 1"
    echo "----------"

    if confirm "Check bootctl status"; then
        bootctl --no-pager status
        pause
    fi

    if confirm "List /boot/ contents"; then
        ls -l "/boot/"
        pause
    fi

    if confirm "Append template to /boot/loader/loader.conf"; then
        cat <<'EOF' >> "/boot/loader/loader.conf"
# -- loader.conf --
default arch.conf
timeout 30
console-mode keep
editor no
EOF
        nano "/boot/loader/loader.conf"
    fi

    if confirm "List /boot/loader/entries/ contents"; then
        ls -l "/boot/loader/entries/"
        pause
    fi

    if confirm "Rename *_linux.conf to arch.conf"; then
        mv /boot/loader/entries/*_linux.conf "/boot/loader/entries/arch.conf"
    fi

    if confirm "Rename *_linux-fallback.conf to arch-fallback.conf"; then
        mv /boot/loader/entries/*_linux-fallback.conf "/boot/loader/entries/arch-fallback.conf"
    fi

    if confirm "Append template to arch.conf"; then
        cat <<'EOF' >> "/boot/loader/entries/arch.conf"
# -- arch.conf --
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=UUID=xx-xx-xx-xx-xx zswap.enabled=0 rw rootfstype=ext4
EOF
        nano "/boot/loader/entries/arch.conf"
    fi

    if confirm "Append template to arch-fallback.conf"; then
        cat <<'EOF' >> "/boot/loader/entries/arch-fallback.conf"
# -- arch-fallback.conf --
title   Arch Fallback
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=UUID=xx-xx-xx-xx-xx zswap.enabled=0 rw rootfstype=ext4
EOF
        nano "/boot/loader/entries/arch-fallback.conf"
    fi

    if confirm "List block devices"; then
        lsblk
        pause
    fi

    if confirm "Create EFI boot entry with efibootmgr"; then
        read -rp "Enter device name (e.g. sda): " disk_name
        read -rp "Enter EFI partition number (e.g. 1): " part
        efibootmgr --create --disk "/dev/$disk_name" --part "$part" --label "Arch Linux" --loader "/EFI/systemd/systemd-bootx64.efi"
        pause
        mkinitcpio -P
    fi

    if confirm "Enable systemd-boot-update.service"; then
        systemctl enable "systemd-boot-update.service"
    fi

    if confirm "Done"; then
    echo "> You are inside chroot. exit chroot and reboot"
    exit 0
    fi

# STAGE 2
# ---------------------
elif [[ "$stage" == "2" ]]; then
    echo "> Stage 2"
    echo "----------"

    # Require sudo if not root
    if [[ $EUID -ne 0 ]]; then
        read -rp "Not running as root. Use sudo? (y/n): " use_sudo
        case "${use_sudo,,}" in
            y|Y)
                SUDO="sudo"
                sudo -v
                ;;
            *)
                echo "Requires elevated privileges. Exiting..."
                exit 1
                ;;
        esac
    else
        SUDO=""
    fi

    if confirm "Add Chaotic-AUR"; then
        $SUDO pacman-key --recv-key 3056513887B78AEB --keyserver "keyserver.ubuntu.com"
        $SUDO pacman-key --lsign-key 3056513887B78AEB
        $SUDO pacman -U "https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst"
        $SUDO pacman -U "https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst"
        $SUDO tee -a /etc/pacman.conf > /dev/null <<'EOF'
[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
EOF
        $SUDO nano "/etc/pacman.conf"
    fi

    if confirm "Install Yay (AUR Helper)"; then
        $SUDO pacman -Syu yay
    fi

    if confirm "Install GNOME Packages & DM"; then
        $SUDO pacman -S gnome-shell gnome-control-center gnome-tweaks gnome-keyring polkit-gnome gnome-themes-extra gnome-disk-utility emptty
    fi

    if confirm "Install Function Packages"; then
        $SUDO pacman -S wget jq wmctrl iwd smartmontools gstreamer gst-plugins-good gst-plugin-pipewire gtk-engine-murrine sassc vte3 libhandy libbacktrace streamlink ntfs-3g mtools exfatprogs dosfstools ffmpegthumbnailer
        yay -S actions-for-nautilus-git ddcutil-service
    fi

    if confirm "Install General App Packages"; then
        $SUDO pacman -S kitty extension-manager zed deskflow mpv zen-browser-bin pamac localsend btop twitch-tui gimp geary gufw feh oh-my-posh fastfetch
    fi

    if confirm "Install Regular Font Packages"; then
        $SUDO pacman -S noto-fonts ttf-roboto ttf-sourcecodepro-nerd
    fi

    if confirm "Install Noto Emoji Font Package (may take a while)"; then
        $SUDO pacman -S noto-fonts-emoji
    fi

    if confirm "Setup UFW defaults"; then
        $SUDO ufw default deny incoming
        $SUDO ufw default allow outgoing
        $SUDO ufw enable
    fi

    if confirm "Enable DM Service and Enter Config"; then
        $SUDO systemctl enable --now emptty.service
        pause
        $SUDO nano /etc/emptty/conf
    fi

    if confirm "Reboot"; then
        reboot
    fi
fi

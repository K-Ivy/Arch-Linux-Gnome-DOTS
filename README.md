# Arch Linux Full Install Guide (Minimal Gnome)
---
### Boot & Connect to Network:
- Enter: `iwctl`
  
  -- `device list`
  
- Power on devices if not on:
  
  -- `device DEVICE set-property powered on`
  
  -- `adapter ADAPTER set-property powered on`
  
- If the device is still not powered on:
  
  -- `rfkill unblock DEVICE`

- Get Networks and Connect:
  
  -- `station NAME scan` (this will not output anything)
  
  -- `station NAME get-networks`
  
  -- `station NAME connect MyWiFiHere-2G`
  
  -- Enter password & type: `exit`
  
- Test: `ping -c 4 google.com`

### Pure Base with Archinstall:
- Enter: `archinstall`
  
  -- Mirror region (`US`),

  -- Disk Config (`Best Effort > Ext4 > Separate /home`),

  -- Bootloader (`Systemd`),

  -- Profile (`Xorg + Drivers`),

  -- Audio (`Pipewire`),
     
  -- Network Config (`Copy to Install` or `Network Manager`),

  -- After installation is done, click `Yes` and CHROOT in.

### Setups in Chroot:
- Enter: `pacman -S nano git`

- Configure/Setup Systemd (Archinstall may not fully do so) + Pre Plymouth Setup:
  
  -- Check entries: `bootctl status`

  -- `ls /boot/` (Check files)

  -- `nano /boot/loader/loader.conf` (Update loader config)

    ```bash
    default  arch.conf
    timeout  30
    console-mode keep
    #editor  no
    ```

  -- `ls /boot/loader/entries/` (Check files)
  
- Change Archinstall default entry name structure:
  
  -- `mv /boot/loader/entries/*_linux.conf /boot/loader/entries/arch.conf`
  
  -- `mv /boot/loader/entries/*_linux-fallback.conf /boot/loader/entries/arch-fallback.conf`
  
- Update `arch.conf` and `arch-fallback.conf`:
  
  -- `nano /boot/loader/entries/arch.conf`
  
  -- `nano /boot/loader/entries/arch-fallback.conf`

    ```plaintext
    -- arch.conf --
    title   Arch Linux
    linux   /vmlinuz-linux
    initrd  /initramfs-linux.img
    options root=UUID=xx-xx-xx-xx-xx zswap.enabled=0 rw rootfstype=ext4 quiet splash loglevel=3 systemd.show_status=auto rd.udev.log_level=3

    -- arch-fallback.conf --
    title   Arch Fallback
    linux   /vmlinuz-linux
    initrd  /initramfs-linux.img
    options root=UUID=xx-xx-xx-xx-xx zswap.enabled=0 rw rootfstype=ext4
    ```

  -- **Options are for "silent boot"** ([Arch Wiki - Silent Boot](https://wiki.archlinux.org/title/Silent_boot))

- Modify `mkinitcpio.conf`:
  
  -- `nano /etc/mkinitcpio.conf`
  
  -- Replace `udev` with `systemd`, remove `fsck` & add `plymouth` in HOOKS:

    ```plaintext
    HOOKS=(base systemd autodetect microcode modconf kms keyboard keymap plymouth block filesystems)
    ```

- Install Plymouth & Theme ([Plymouth Theme](https://github.com/catppuccin/plymouth)):
  
  -- `sudo pacman -S plymouth`

  -- `cd /tmp`

  -- `git clone https://github.com/K-Ivy/Arch-Linux-Gnome-DOTS.git`

  -- `cp -r plymouth/catppuccin-frappe-twd /usr/share/plymouth/themes/catppuccin-frappe-twd`

  -- `sudo plymouth-set-default-theme -R catppuccin-frappe-twd`

- Create the boot entry to finish:
  
  -- **Note**: Replace `--part` with the partition containing the EFI (/boot marked)

  -- `lsblk`

  -- `efibootmgr --create --disk /dev/sda --part 1 --label "Arch Linux" --loader /EFI/systemd/systemd-bootx64.efi`

  **This video shows for GRUB:** [YouTube Video](https://www.youtube.com/watch?v=mWl4P6DOt9M)

- `sudo mkinitcpio -P`
  
  -- Check Entry: `bootctl status`
  
- Enable update service: `sudo systemctl enable systemd-boot-update.service`

### Reboot

---

## ALT Method: Connecting to a Network (if needed)
- `nmcli device`
  -- `nmcli device wifi`
- `nmcli dev wifi connect MyWiFiHere-2G password PASSWORD-HERE`

---

## Manual Chroot Guide (if needed):
- Boot back into the live environment using the USB.
  -- Once loaded, check partitions: `lsblk`
  -- Mount Root (Main Filesystem): `mount /dev/sdaX /mnt`
  -- Mount EFI (/boot Partition): `mount /dev/sdaX /mnt/boot`
  -- Mount Home (if separated): `mount /dev/sdaX /mnt/home`
  -- Chroot: `arch-chroot /mnt`
- Make sure to connect to a network using the above methods.
- When done:
  -- `exit`
  -- `umount -R /mnt`
  -- `reboot` (unplug USB when the screen blanks)

---

## Install Packages (Full Setup Before Boot):
- **Chaotic-AUR**:
  -- `sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com`
  -- `sudo pacman-key --lsign-key 3056513887B78AEB`
  -- `sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'`
  -- `sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'`
  -- `sudo nano /etc/pacman.conf`

    ```plaintext
    -- pacman.conf --
    [chaotic-aur]
    Include = /etc/pacman.d/chaotic-mirrorlist
    ```

  -- `sudo pacman -Syu yay`
  -- Install via `yay`: `yay -S yt-x gpufetch-nocuda-git actions-for-nautilus ddcutil-service`
- Gnome: `gnome-shell gnome-control-center gnome-tweaks gnome-keyring polkit-gnome gnome-themes-extra gnome-disk-utility`
- Display Manager: `sddm`
- Apps: `kitty extension-manager zed deskflow mpv librewolf gcolor3 pamac localsend btop twitch-tui loupe gimp`
- Fonts: `ttf-dejavu ttf-liberation noto-fonts noto-fonts-emoji ttf-roboto`

---

## Additional Configurations:
Refer to the detailed setup for:
- SDDM Theming
- Dotfiles and Configs
- Browser Settings (LibreWolf, Zen Browser)
- Extension Customizations
- Gnome Theming (Graphite GTK, Gruvbox Icons, Capitaine Cursor)

---





<details>
<summary>Boot & Connect to Network</summary>
  
</details> 

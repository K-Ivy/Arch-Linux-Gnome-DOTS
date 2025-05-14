# Arch Linux Full Install Guide (Minimal Gnome)
### ∘ 1. Boot & Connect to Network
<details>
<summary>↳ Expand</summary>

- Enter: `iwctl`
  
  ⎯ `device list`
  
- Power on devices if not on:
  
  ⎯ `device DEVICE set-property powered on`
  
  ⎯ `adapter ADAPTER set-property powered on`
  
- If the device is still not powered on:
  
  ⎯ `rfkill unblock DEVICE`

- Get Networks and Connect:
  
  ⎯ `station NAME scan` (this will not output anything)
  
  ⎯ `station NAME get-networks`
  
  ⎯ `station NAME connect MyWiFiHere-2G`
  
  ⎯ Enter password & type: `exit`
  
- Test: `ping -c 4 google.com`

</details> 

### ∘ 2. Pure Base with Archinstall
<details>
<summary>↳ Expand</summary>
  
- Enter: `archinstall`
  
  ⎯ Configure options. Main:

  ⎯ Disk Config (`Best Effort > Ext4 > Separate /home`),

  ⎯ Bootloader (`Systemd`),

  ⎯ Profile (`Xorg + Drivers`),

  ⎯ Audio (`Pipewire`),
     
  ⎯ Network Config (`Copy to Install` or `Network Manager`),

  ⎯ After installation is done, select `Yes` and CHROOT in.

</details> 

### ∘ 3. Setups in Chroot
<details>
<summary>↳ Expand</summary>

- Enter: `pacman -S nano git`

- Configure/Setup Systemd (Archinstall may not fully do so) + Pre Plymouth Setup:
  
  ⎯ Check entries: `bootctl status`

  ⎯ `ls /boot/` (Check files)

  ⎯ `nano /boot/loader/loader.conf` (Update loader config)

    ```bash
    default  arch.conf
    timeout  30
    console-mode keep
    #editor  no
    ```

  ⎯ `ls /boot/loader/entries/` (Check files)
  
- Change Archinstall default entry name structure:
  
  ⎯ `mv /boot/loader/entries/*_linux.conf /boot/loader/entries/arch.conf`
  
  ⎯ `mv /boot/loader/entries/*_linux-fallback.conf /boot/loader/entries/arch-fallback.conf`
  
- Update `arch.conf` and `arch-fallback.conf`:
  
  ⎯ `nano /boot/loader/entries/arch.conf`
  
  ⎯ `nano /boot/loader/entries/arch-fallback.conf`

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
    
  ⎯ **Options are for "silent boot"** ([Arch Wiki - Silent Boot](https://wiki.archlinux.org/title/Silent_boot))

- Modify `mkinitcpio.conf` (silent boot + plymouth opts):
  
  ⎯ `nano /etc/mkinitcpio.conf`
  
  ⎯ Replace `udev` with `systemd`, remove `fsck` & add `plymouth` in HOOKS:

    ```plaintext
    HOOKS=(base systemd autodetect microcode modconf kms keyboard keymap plymouth block filesystems)
    ```

- Install Plymouth & Theme ([Plymouth Theme](https://github.com/catppuccin/plymouth)):
  
  ⎯ `sudo pacman -S plymouth`

  ⎯ `cd /tmp`

  ⎯ `git clone https://github.com/K-Ivy/Arch-Linux-Gnome-DOTS.git`

  ⎯ `cp -r plymouth/catppuccin-frappe-twd /usr/share/plymouth/themes/catppuccin-frappe-twd`

  ⎯ `sudo plymouth-set-default-theme -R catppuccin-frappe-twd`

- Create the boot entry to finish:
  
  ⎯ **Note**: Replace `--part` with the partition containing the EFI (/boot marked)

  ⎯ `lsblk`

  ⎯ `efibootmgr --create --disk /dev/sda --part 1 --label "Arch Linux" --loader /EFI/systemd/systemd-bootx64.efi`

  **This video shows for GRUB:** [YouTube Video](https://www.youtube.com/watch?v=mWl4P6DOt9M)

- `sudo mkinitcpio -P`
  
- Check Entry: `bootctl status`
  
- Enable update service: `sudo systemctl enable systemd-boot-update.service`

- Reboot: `reboot` 
  
</details> 

**▰ Alt method to connect to a network after reboot (if needed):**
<details>
<summary>↳ Expand</summary>
  
- `nmcli device`
  
  ⎯ `nmcli device wifi`
  
- `nmcli dev wifi connect MyWiFiHere-2G password PASSWORD-HERE`

</details> 

**▰ Manual Chroot Guide (if needed):**
<details>
<summary>↳ Expand</summary>

- Boot back into the live environment using the USB.
  
  ⎯ Once loaded, check partitions: `lsblk`
  
  ⎯ Mount Root (Main Filesystem): `mount /dev/sdaX /mnt`
  
  ⎯ Mount EFI (/boot Partition): `mount /dev/sdaX /mnt/boot`
  
  ⎯ Mount Home (if separated): `mount /dev/sdaX /mnt/home`
  
  ⎯ Chroot: `arch-chroot /mnt`
  
- Make sure to connect to a network using the methods.
  
- When done:

  ⎯ `exit`
  
  ⎯ `umount -R /mnt`
  
  ⎯ `reboot` (unplug USB when the screen blanks)

</details> 

### ∘ 4. Install Packages + Setup DM:
<details>
<summary>↳ Expand</summary>

- **Add Chaotic-AUR**:
  
  ⎯ `sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com`
  
  ⎯ `sudo pacman-key --lsign-key 3056513887B78AEB`
  
  ⎯ `sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'`
  
  ⎯ `sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'`
  
  ⎯ `sudo nano /etc/pacman.conf` (Add the below to the bottom)

    ```plaintext
    -- pacman.conf --
    [chaotic-aur]
    Include = /etc/pacman.d/chaotic-mirrorlist
    ```

  ⎯ `sudo pacman -Syu yay`
  
- **Gnome + DM** ⎯ `sudo pacman -S gnome-shell gnome-control-center gnome-tweaks gnome-keyring polkit-gnome gnome-themes-extra gnome-disk-utility loupe sddm`

- **Functions** ⎯ `sudo pacman -S wget jq wmctrl wpa_supplicant smartmontools gstreamer gst-plugins-good gst-plugin-pipewire wireless_tools gtk-engine-murrine sassc xclip vte3 libhandy zenity libbacktrace streamlink ntfs-3g mtools exfatprogs dosfstools nautilus-image-converter nautilus-code-git oh-my-posh cpufetch fastfetch`
  
- **Apps** ⎯ `sudo pacman -S kitty extension-manager zed deskflow mpv librewolf gcolor3 pamac localsend btop twitch-tui gimp`

- **+ Via Yay** ⎯ `yay -S yt-x gpufetch-nocuda-git actions-for-nautilus ddcutil-service`

- **Fonts** ⎯ `sudo pacman -S ttf-dejavu ttf-liberation noto-fonts noto-fonts-emoji ttf-roboto ttf-droid ttf-0xproto-nerd ttf-sourcecodepro-nerd`

- **SDDM SETUP:**
  
  ⎯ Theme: `https://github.com/Keyitdev/sddm-astronaut-theme`
  
  ⎯ Install: `sudo pacman -S sddm-astronaut-theme` (chaotic-aur)
  
  ⎯ Conf: `sudo nano /etc/sddm.conf`

    ```plaintext
    -- sddm.conf --
    [Theme]
    Current=sddm-astronaut-theme
    ```
    
  ⎯ Set theme: `sudo nano /usr/share/sddm/themes/sddm-astronaut-theme/metadata.desktop`
  
    ```plaintext
    -- metadata.desktop --
    ConfigFile=Themes/pixel_sakura.conf
    ```
    
  ⎯ Enable: `systemctl enable sddm`

- **Reboot. All setup!**
 
</details> 

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

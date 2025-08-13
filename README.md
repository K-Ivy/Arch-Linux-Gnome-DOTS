Personal dots/info for own reference/storage

<details>
<summary><strong>Previews </strong></summary>
Quick Preview of latest (8/11/25):

[Screencast From 2025-08-11 14-25-33.webm](https://github.com/user-attachments/assets/588d7d37-685f-4763-880d-d22ea02ec244)

</details>

<details>
<summary><strong>Base Setup Install </strong></summary>

### 1. Boot & Connect to Network
<details>
<summary>↳ Expand</summary>

- Enter: `iwctl`

  - `device list`

- Power on devices if not on:

  - `device DEVICE set-property powered on`

  - `adapter ADAPTER set-property powered on`

- If the device is still not powered on:

  - `rfkill unblock DEVICE`

- Get Networks and Connect:

  - `station NAME scan` (this will not output anything)

  - `station NAME get-networks`

  - `station NAME connect MyWiFiHere-2G`

  - Enter password & type: `exit`

- Test: `ping -c 4 google.com`

</details>

### 2. Base with Archinstall
<details>
<summary>↳ Expand</summary>

- Enter: `archinstall`

  - Configure options. Main:

  - Disk Config (`Best Effort > Ext4 > Separate /home`),

  - Bootloader (`Systemd`),

  - Profile (`Xorg + Drivers`),

  - Audio (`Pipewire`),

  - Network Config (`Copy to Install`),

  - After installation is done, select `Yes` and CHROOT in.

</details>

### 3. Setups in Chroot
<details>
<summary>↳ Expand</summary>

- Enter: `pacman -S nano git`

- For the rest on the setup below, wip guided setup to avoid having to type:

- `git clone https://github.com/K-Ivy/Arch-Linux-Gnome-DOTS.git /tmp/dots && cd /tmp/dots/extra && bash ag-install.sh`

---

- Configure/Setup Systemd (Archinstall may not fully do so):

  - Check entries: `bootctl status`

  - `ls /boot/` (Check files)

  - `nano /boot/loader/loader.conf` (Update loader config)

    ```bash
    default  arch.conf
    timeout  30
    console-mode keep
    #editor  no
    ```

  - `ls /boot/loader/entries/` (Check files)

- Change Archinstall default entry name structure:

  - `mv /boot/loader/entries/*_linux.conf /boot/loader/entries/arch.conf`

  - `mv /boot/loader/entries/*_linux-fallback.conf /boot/loader/entries/arch-fallback.conf`

- Update `arch.conf` and `arch-fallback.conf`:

  - `nano /boot/loader/entries/arch.conf`

  - `nano /boot/loader/entries/arch-fallback.conf`

    ```plaintext
    -- arch.conf --
    title   Arch Linux
    linux   /vmlinuz-linux
    initrd  /initramfs-linux.img
    options root=UUID=xx-xx-xx-xx-xx zswap.enabled=0 rw rootfstype=ext4

    -- arch-fallback.conf --
    title   Arch Fallback
    linux   /vmlinuz-linux
    initrd  /initramfs-linux.img
    options root=UUID=xx-xx-xx-xx-xx zswap.enabled=0 rw rootfstype=ext4
    ```

- Create the boot entry to finish:

  - **Note**: `--part` number is the partition containing the EFI (/boot marked)

  - `lsblk`

  - `efibootmgr --create --disk /dev/sda --part 1 --label "Arch Linux" --loader /EFI/systemd/systemd-bootx64.efi`

       - Grub note for future reference: 1. pacman -S grub efibootmgr dosfstools mtools |  2. grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB | grub-mkconfig -o /boot/grub/grub.cfg

- `sudo mkinitcpio -P`

- Check Entry: `bootctl status`

- Enable update service: `sudo systemctl enable systemd-boot-update.service`

- Reboot: `reboot`

</details>

**Alt method to connect to a network**
<details>
<summary>↳ Expand</summary>

- `nmcli device`

  - `nmcli device wifi`

- `nmcli dev wifi connect MyWiFiHere-2G password PASSWORD-HERE`

</details>

**Manual Chroot Guide:**
<details>
<summary>↳ Expand</summary>

- Boot back into the live environment using USB.

  - Once loaded, check partitions: `lsblk`

  - Mount Root (Main Filesystem): `mount /dev/sdaX /mnt`

  - Mount EFI (/boot Partition): `mount /dev/sdaX /mnt/boot`

  - Mount Home (if separated): `mount /dev/sdaX /mnt/home`

  - Chroot: `arch-chroot /mnt`

- Make sure to connect to a network using the methods.

- When done:

  - `exit`

  - `umount -R /mnt`

  - `reboot` (unplug USB when the screen blanks)

</details>

### 4. Install Packages + Setup DM:
<details>
<summary>↳ Expand</summary>

- **Add Chaotic-AUR**:

  - `sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com`

  - `sudo pacman-key --lsign-key 3056513887B78AEB`

  - `sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'`

  - `sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'`

  - `sudo nano /etc/pacman.conf` (Add the below to the bottom)

    ```plaintext
    -- pacman.conf --
    [chaotic-aur]
    Include = /etc/pacman.d/chaotic-mirrorlist
    ```

  ⎯ `sudo pacman -Syu yay`

- **Gnome + DM** - `sudo pacman -S gnome-shell gnome-control-center gnome-tweaks gnome-keyring polkit-gnome gnome-themes-extra gnome-disk-utility emptty`

- **Functions** - `sudo pacman -S wget jq wmctrl iwd smartmontools gstreamer gst-plugins-good gst-plugin-pipewire gtk-engine-murrine sassc vte3 libhandy libbacktrace streamlink ntfs-3g mtools exfatprogs dosfstools oh-my-posh ffmpegthumbnailer feh gufw`

       - **Via Yay** ⎯ `yay -S actions-for-nautilus ddcutil-service`

- **Apps** - `sudo pacman -S kitty extension-manager zed deskflow mpv zen-browser-bin pamac localsend btop twitch-tui gimp geary`

- **Fonts** - `sudo pacman -S noto-fonts noto-fonts-emoji ttf-roboto ttf-sourcecodepro-nerd`

- UFW setup:
     - sudo ufw default deny incoming
     - sudo ufw default allow outgoing
     - sudo ufw enable

- Reboot.

</details>

</details>


<details>
<summary><strong>Additional Config Notes</strong></summary>

### ∘ Fastfetch
<details>
<summary>↳ Expand</summary>

- **Edit GPU Section**:

  - Open "config.jsonc" in .config folder and edit "gpu" section. Choose which to use and if text entry, edit it to be correct

</details>

### ∘ Gnome Extensions
<details>
<summary>↳ Expand</summary>

- List and settings backups are in /home/.local/share/gnome-shell

**Main:**

- Apps Icons Taskbar
- Burn My Windows
- Caffeine
- Dash To Panel
- Disable Menu Switching
- Display Adjustment
- Extension List
- Flippery Panel Favorites
- Fullscreen to Empty Workspace2
- Quick Settings Tweaks
- Rocketbar
- Rounded Window Corners Reborn
- Spacebar
- Top Bar Organizer
- Transparent Window Moving
- V-Shell
- User Themes

**Extra:**

- Looking Glass Button
- Blur My Shell
- Coverflow Alt-Tab
- Edit Desktop Files
- ddterm
- Forge
- Useless Gaps

**Of Note:**

- AppIndicator and KStatusNotifierItem Support
- Status Icons
- Tray Icons Reloaded
- Application Tabs
- Custom Command Menu
- Custom Command Toggle
- Favorite Apps Menu
- Hide Accessibility Menu
- Hide Screen Sharing
- Launcher
- Lineup
- Media Controls
- No Titlebar When Maximized
- QuickSettings Indicator Visibility Tool
- Toggler
- Show Desktop Button
- Truly Maximized Windows
- Undecorated Windows

</details>

### ∘ Gnome Theming
<details>
<summary>↳ Expand</summary>

- **Windows and Overall**:

  - Download ZIP: https://github.com/Fausto-Korpsvart/Everforest-GTK-Theme

  - Open terminal and CD into the extracted folder.

    - Enter: `./install.sh --tweaks macos float outline -c dark`.

  - Once installed, replace with the gnome-shell.css in `/home/.themes/Evernordic-Dark/gnome-shell`. If original is updated and current here outdated, replace as needed (instructions within the gnome-shell.css)

- **Gruvbox Plus Dark Icons**:

  - Download ZIP: https://github.com/SylEleuth/gruvbox-plus-icon-pack

  - Create an `icons` folder at: `/home/USER/.local/share/icons` & bookmark it.

    - Copy `Gruvbox-Plus-Dark` and Light variant into the folder.

  - Open Terminal & CD into extracted folder: `~/gruvbox-plus-icon-pack-master/scripts`.

    - `chmod +x folders-color-chooser`.

    - `./folders-color-chooser -c blue`.

- **Capitaine Cursor**:

  - Download ZIP: https://github.com/sainnhe/capitaine-cursors

  - Extract and copy "Gruvbox", "Nord", "Palenight" standard variants into `~/.local/share/icons`

    - **Additional Cursors**: [Catppuccin Cursors](https://github.com/catppuccin/cursors).

- **Apply**:

  - Open *Gnome Tweaks* and select.

</details>

</details>

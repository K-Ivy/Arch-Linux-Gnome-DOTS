This Repo is mainly a reference point (and storage)

(6/1/2025):

https://github.com/user-attachments/assets/371de060-3936-4880-9df7-4d4dde15ae9b

---

# Arch Linux Install (Minimal Gnome)

### 1. Boot & Connect to Network
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

### 2. Base with Archinstall
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

### 3. Setups in Chroot
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

  ⎯ `cp -r plymouth/catppuccin-frappe-twd /usr/share/plymouth/catppuccin-frappe-twd`

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

### 4. Install Packages + Setup DM:
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

- **Gnome + DM** ⎯ `sudo pacman -S gnome-shell gnome-control-center gnome-tweaks gnome-keyring polkit-gnome gnome-themes-extra gnome-disk-utility sddm`

- **Functions** ⎯ `sudo pacman -S wget jq wmctrl wpa_supplicant smartmontools gstreamer gst-plugins-good gst-plugin-pipewire wireless_tools gtk-engine-murrine sassc xclip vte3 libhandy zenity libbacktrace streamlink ntfs-3g mtools exfatprogs dosfstools nautilus-image-converter oh-my-posh cpufetch fastfetch ffmpegthumbnailer feh gufw`

- **Apps** ⎯ `sudo pacman -S kitty extension-manager zed deskflow mpv microsoft-edge-stable-bin gcolor3 pamac localsend btop twitch-tui gimp`

- **+ Via Yay** ⎯ `yay -S yt-x gpufetch-nocuda-git actions-for-nautilus ddcutil-service`

- **Fonts** ⎯ `sudo pacman -S noto-fonts noto-fonts-emoji ttf-roboto ttf-sourcecodepro-nerd`

- **SDDM SETUP:** (Theme config in repo)

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

- UFW first setup:
     - sudo ufw default deny incoming
     - sudo ufw default allow outgoing
     - sudo ufw enable

- **Reboot. All setup.**

Note opt:

- systemctl list-unit-files --state=enabled

- sudo systemctl disable --now remote-fs.target

</details>

---

# Desktop Configurations
### ∘ Setup Configs
<details>
<summary>↳ Expand</summary>

- Open Nautilus, press `Ctrl + H` to show hidden files or toggle via settings.

  ⎯ Go to `/home/USER/Templates` and bookmark it.

  > Anything in this path gets added to the "New Document" content menu for fast file creation.

  ⎯ Go to `/home/USER/.config` and bookmark it.

- Copy contents of `home/Templates/` from GIT REPO to `~/USER/Templates`

- Copy contents of `.configs/` from GIT REPO to `~/USER/.config/`

</details>

### ∘ Bashrc Setup + Oh-My-Posh + Apps Folder
<details>
<summary>↳ Expand</summary>

- Get `.bashrc` from `home/` in the repo and update contents of the one in `/home/USER/` or replace:

  ⎯ **Ensure to update paths**:

    ```bash
    eval "$(oh-my-posh init bash --config /home/k/.config/ohmyposh/config.json)"
    export PATH="$PATH:/home/k/Documents/Apps"
    ...
    ```

- **Create Apps Directory**:

  ⎯ `/home/USER/Documents/Apps`

  ⎯ Copy contents from repo's `home/Documents/Apps/` into the created path or replace.

- **Reload Shell**:

  ⎯ `source ~/.bashrc`

</details>

### ∘ Actions-for-Nautilus
<details>
<summary>↳ Expand</summary>

- Create directory: `/home/USER/.local/share/actions-for-nautilus` (or run the app).

- Copy contents from repo's `home/.local/share/actions-for-nautilus` to the created path or replace.

- Restart Nautilus:

  ⎯ `nautilus -q` in terminal.

</details>

### ∘ Fastfetch
<details>
<summary>↳ Expand</summary>

- **Edit GPU Section**:

  ⎯ Open "config.jsonc" in .config folder and edit "gpu" section. Choose which to use and if
    text entry, edit it to be correct

</details>

### ∘ Gnome Extension Customizations
<details>
<summary>↳ Expand</summary>

- **Open Extension Manager and install:**

    - `DDTerm`, `User Themes`, `Display Adjustment`, `Rounded Window Corners Reborn`, `Custom Command Menu`, `V-Shell`, `App Icons Taskbar`, `App Menu is back`, `Burn my Windows`, `Screenshort-cut`, `Rocketbar`, `Space Bar`, `Transparent Window Moving`, `Truly Maximized Windows`, `Blur My Shell`.

    - **Of Note/Alts**: `Customized Workspaces`, `Fullscreen to New Workspace`, `Clipboard History`, `Dash to Panel`, `Date Menu Formatter`, `Forge`, `Mouse Tail`, `PaperWM`, `Start Overlay in Application View`, `Task Up UltraLite`

- **App Icons Taskbar**: Dash on panel + other adjustments

  ⎯ As it has opt to export settings, find in repo's `exported-extension-settings`.

- **DDTerm**: On-demand Terminal

  ⎯ **Window:**

    - Window Size: `100%`

    - Resizable: `False`

    - On All Workplaces: `False`

    - Show Tab Bar: `Never`

  ⎯ **Terminal:**

    - Font: `SauceCodePro Nerd Font Medium - 13`

    - Cursor Shape: `I-Beam`

    - Background: `#292E38`

    - Foreground: `#D8E5E5`

    - Background Opacity: `54%`

    - Show Scrollbar: `False`.

- **Custom Command Menu**: To put name on toolbar and have easy access to commands

    - Exported commands in repo's `home/commands.ini`.

    - Configuration > Custom Menu Title: Type `Icon` > `pan-down-symbolic`.

- **Rocketbar**: Right click in overview opens applications view

  ⎯ **General:**

    - Taskbar Enabled: `False`

    - Notification Counter: `False`


  ⎯ **Behavior:**

    - Everything off except Overview option

- **Rounded Window Corners Reborn**: Consistent Borders on everything

  ⎯ **Main:**

    - Skip LibAdwaita: `True`.

    - Skip LibHandy: `True`.

    - Border Width: `-2`.

    - Border Color: `#83B9B8`.

    - Corner Radius: `11`.

    - Smoothing: `0`.

  ⎯ **Window Shadow for Focused State:**

    - Horizontal Offset: `0`.

    - Vertical Offset: `5`.

    - Blur Radius: `12`.

    - Spread Radius: `2.0`.

    - Opacity: `62`.

  ⎯ **Window Shadow for Unfocused State:**

    - Set all options to `0`.

  ⎯ **Additional:**

    - Add rounded corners to Kitty Term on Wayland: `True` if needed.

    - Custom > Add > Window Class: `mpvk` > Bottom & Right Padding: `2` (to fix it's border)

- **Space Bar**: Workspaces buttons on panel

  ⎯ **Behavior:**

    - Indicator Style: `Workspace Bar` -> `Use Custom Label` & Unnamed Label: `Space ((Number))`

    - Position: `Left`.

    - Switch: `Over Indicator`.

    - Always Show Numbers: `False`.

    - Show Empty Workspaces: `True`.

    - Toggle Overview: `False`.

  ⎯ **Appearance:**

    - Padding & Margin: `0`.

    - Border Radius + Width & Vertical Padding: `0`.

    - Horizontal Padding: `13`.

    - Background & Border Colors: `#000000`.

    - Font Size: `10`.

    - Font Weight: `Semi-Bold`.

    - Active Text Color: `#9DBDB8`.

    - Inactive Text Color: `#7F9EA0`.

    - Empty Text Color: `#7F9EA0`.

- **Transparent Window Moving**: Visual

  ⎯ Opacity: `230`.

- **Blur My Shell**: Transparency for certain applications. Keep usage on short-term apps for performace

  ⎯ **Note**: Enable `Rounded Corners Reloaded` first and then this extension.

  ⎯ Remove default pipeline effects.

  ⎯ Disable blurs for `Panel`, `Overview`, and `Dash`.

  ⎯ **Applications:**

    - Sigma: `4`.

    - Brightness: `1.00`.

    - Opacity: `226`.

    - Opaque Focused Window: `False`.

    - Overview Blur: `False`.

    - Whitelist Applications: `Nautilus`.

- **Burn my Windows**: Window close and appear animation

  ⎯ Settings are within repo's `.config/`

- **V-Shell (Vertical Workspaces)**: Customize Gnome behavior and overview

  ⎯ **Modules**:

     - Disable `Layout`, `Swipe Tracker`, `Dash`, `Workspace Switcher Popup`.

  ⎯ **Layout**:

     - \Dash > Position: `Bottom`.

     - \Dash > Center Dash to Workspace: `True`.

     - \Dash > Icon Position: `Start`.

     - Workspace Thumbnails > Pos/Orientation: `Top | Horizontal`.

     - Workspace Thumbnails > Window Scale: `12`.

     - Workspace Thumbnails > App Scale: `14`.

     - Workspace Preview > Scale: `62`.

     - Workspace Preview > Spacing: `500`.

     - App Grid > Center Grid: `True`.

     - Search View > Center: `True`.

     - Search View > Always Show: `False`.

     - Search View > Results Width: `90`.

     - \Workspace Switch Popup > Horizontal Pos: `50`.

     - \Workspace Switch Popup > Vertical Pos: `5`.

     - Notifications/OSD > Banner: `Top Center`.

     - Notifications/OSD > Popup: `Top Center`.

     - Adjust `Secondary Monitor` settings if needed.

  ⎯ **Appearance:**

     - \Dash > Icon Size: `64`.

     - \Dash > Style: `Default`.

     - \Dash > Opacity: `60`.

     - \Dash > Radius: `30`.

     - \Dash > App Indicator: `Dot`.

     - Workspace Thumbnails > Labels: `Disabled`.

     - Workspace Thumbnails > Wallpaper in Thumbnail: `True`.

     - Window Preview > Icon Size: `Disable`.

     - Window Preview > Position / Visibility: `Below Window`.

     - Workspace Preview > Corner Radius: `42`.

     - Search > Icon Size: `96`.

     - Search > Results Rows: `3`.

     - Search > Highlighting: `Underline`.

     - Panel > Style: `Same As Desktop`.

     - Overview Background > Show Wallpaper: `Enable - Fast Blur Transition`.

     - Overview Background > Brightness (for all): `47`.

     - Overview Background > Blur (for both): `30`.

  ⎯ **Behavior**:

     - Overview > Escape Key Behavior: `Default`.

     - Overview > Click Empty Space to Close: `False`.

     - Overlay Key > Double-Press Action: `Disable`.

     - App Menu > All options: `On`, except `Create Window Thumbnail`.

     - Workspace Thumbnails > Close Button: `Single Click`.

     - Workspace Preview > Sort & Initial: `Default`.

     - Workspace Preview > Height Compensation: `15`.

     - Window Preview > All actions: `Activate Windows`.

     - Always Activate: `False`.

     - Animations > Speed: `108`.

     - Animations > App Grid: `Disable`.

     - Animations > Search View: `Disable`.

     - Animations > Workspace Preview: `Active Workspace Only`.

     - Workspace Switcher > Wraparound: `True`.

     - Workspace Switcher > Animation: `Static Background`.

     - Workspace Switcher > Popup Mode: `Current Monitor`.

     - Notifications > Attention Handler & Favorites: `Disable`.

  ⎯ **App Grid**:

     - Main App Grid > Icon Size: `96`.

     - Main App Grid > Columns & Rows: `3`.

     - Main App Grid > Allow Incomplete Pages: `True`.

     - App Folders > Icon Size: `96`.

     - App Folders > Columns & Rows: `3`.

     - App Folders > Center Open Folders: `True`.

</details>

### ∘ Gnome Theming
<details>
<summary>↳ Expand</summary>

- **Graphite GTK Theme**: Windows and Overall

  ⎯ Download ZIP: https://github.com/vinceliuice/Graphite-gtk-theme

  ⎯ Open terminal and CD into the extracted folder.

    - Now enter: `./install.sh --tweaks normal colorful nord -t teal -c dark -l`.

- **Gruvbox Plus Dark Icons**:

  ⎯ Download ZIP: https://github.com/SylEleuth/gruvbox-plus-icon-pack

  ⎯ Create an `icons` folder at: `/home/USER/.local/share/icons` & bookmark it.

    - Copy `Gruvbox-Plus-Dark` and Light variant into the folder.

  ⎯ Open Terminal & CD into extracted folder: `~/gruvbox-plus-icon-pack-master/scripts`.

    - `chmod +x folders-color-chooser`.

    - `./folders-color-chooser -c blue`.

- **Capitaine Cursor**:

  ⎯ Download ZIP: https://github.com/sainnhe/capitaine-cursors

  ⎯ Extract and copy "Gruvbox", "Nord", "Palenight" standard variants into `~/.local/share/icons`

    - **Additional Cursors**: [Catppuccin Cursors](https://github.com/catppuccin/cursors).

- **Apply**:

  ⎯ Open *Gnome Tweaks* and select.

- **Open** *`/home/USER/.themes/Graphite-teal-Dark-nord/gnome-shell/gnome-shell.css`* **to change some things:**

  ⎯ The updated gnome-shell css can be found in repo's `home/.themes/Graphite-teal-Dark-nord/gnome-shell/gnome-shell.css`.

    - **0. Add to the top:**

  ```css
   /* Top Bar push */
   #panel {
     margin-top: 3px;
   }

   /* Top Bar content push */
   #panel .panel-button {
     margin-right: 6px !important;
     margin-left: 5px !important;
   }

   /* Defaults */
   #panel Gjs_ui_panelMenu_PanelMenuButton.panel-button,
   #panel Gjs_ui_panelMenu_PanelMenuButton.panel-button:hover {
     color: #9dbdb8;
     border-radius: 13px !important;
   }

   /* Custom Command Menu extension */
   #panel Gjs_custom-command-list_storageb_github_com_extension_CommandMenu.panel-button,
   #panel Gjs_custom-command-list_storageb_github_com_extension_CommandMenu.panel-button:hover {
     color: #c89dbf;
   }
  ```

    - **1. Search "Top Bar"** in the editor and change background color to match wallpaper:

  ```css
   #panel {
     ...
     background-color: #272838;
     ...
   }
  ```

    - **2. Scroll down** and change button hpadding:

  ```css
   #panel .panel-button {
     -natural-hpadding: 8px;
     -minimum-hpadding: 8px;
     ...
   }
  ```

    - **3. Change the border radius** of the clock/date display:

  ```css
   #panel .panel-button.clock-display .clock {
     ...
     border-radius: 13px;
	 ...
   }
  ```

    - **4. Change the default hover color**

  ```css
   #panel .panel-button:hover {
     color: white -> #9dbdb8;
	 ...
   }
  ```

    - **5. "Show Apps" Fix**: If "Show Apps" Button is white & not matching "Gruvbox Plus" (Prev Setup). Use Finder & Search ".show-apps" & find the below & update.

  ```css
   #dash .dash-item-container .show-apps .overview-icon,
   #dash .dash-item-container .overview-tile .overview-icon,
   #dash .dash-item-container .grid-search-result .overview-icon {
     color: #ebdbb2;
   }
  ```

    - **6. "Show Apps" Icon Size Fix**: Change the "Show Apps" icon itself so it is larger to match

    - Go to repo's `assets/` folder:

    - Choose an adjusted Gruvbox Plus Icon.

    - Remove `(Option #)` from the name.

    - Copy to `/home/USER/.local/share/icons/Gruvbox-Plus-Dark/actions/symbolic`.

    - **Reload Shell**: press `Alt + F2`, & send `r`.

</details>

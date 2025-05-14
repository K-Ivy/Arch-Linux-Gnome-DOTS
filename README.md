# Arch Linux Fresh Install Step by Step (Minimal GNOME)

<details>
<summary>Boot & Connect to Network</summary>
  
---
  
 1. **Enter:** "iwctl"
  
 -  "device list"

 2. **Power on devices if not on:**
 
 -  "device DEVICE set-property powered on"

 -  "adapter ADAPTER set-property powered on"

 2.5 **If device is still not powered on:**
 
 -  "rfkill unblock DEVICE"
 
 3.  "station NAME scan" (*this will not output anything*)

 -  "station NAME get-networks"

 -  "station NAME connect MyWiFiHere-2G"

 -  Enter password & type: "exit"

 4. **Test: "ping -c 4 google.com"**

 ---
 
</details> 

<details>
<summary>Base via Archinstall </summary>
  
---

 1. **Enter: "archinstall"**

 -  Mirror region ("US"), Disk Config ("Best Effort" > "Ext4" > "Seperate /home"),
   
 -  Bootloader ("Systemd"), Profile ("Xorg" + "Intel Drivers"), Audio ("Pipewire"),
   
 -  Network Config ("Copy to Install" or "Network Manager")
   
 2. **After install is done, click "Yes" and CHROOT in.**

---

</details> 

<details>
<summary>Setup in Chroot</summary>

---

1. pacman -S nano git  

2. Check current boot entries and files  

- bootctl status  

- ls /boot/  

3. Edit the main loader configuration  

- nano /boot/loader/loader.conf  

---

 default      arch.conf  

 timeout      30  

 console-mode keep  

 #editor      no  

---

4. Rename the entry files
   
- ls /boot/loader/entries/  

- mv /boot/loader/entries/*_linux.conf \
  
   /boot/loader/entries/arch.conf  

- mv /boot/loader/entries/*_linux-fallback.conf \
  
   /boot/loader/entries/arch-fallback.conf  

5. Update arch.conf
   
- nano /boot/loader/entries/arch.conf  

---

 title   Arch Linux  

 linux   /vmlinuz-linux  

 initrd  /initramfs-linux.img  

 options root=UUID=xx-xx-xx-xx-xx zswap.enabled=0 \  

         rw rootfstype=ext4 quiet splash \  

         loglevel=3 systemd.show_status=auto \  

         rd.udev.log_level=3  

--

# 6. Update arch-fallback.conf  
nano /boot/loader/entries/arch-fallback.conf  

# ───────────────────────────────────────────────────────  

# title   Arch Fallback  
# linux   /vmlinuz-linux  
# initrd  /initramfs-linux.img  
# options root=UUID=xx-xx-xx-xx-xx zswap.enabled=0 \  
#         rw rootfstype=ext4  

# ───────────────────────────────────────────────────────  

# (Opts are for “silent boot”: https://wiki.archlinux.org/title/Silent_boot)  

# 7. Modify initramfs hooks for Plymouth  
nano /etc/mkinitcpio.conf  

# Replace HOOKS line with:  
# HOOKS=(base systemd autodetect microcode modconf \  
#        kms keyboard keymap plymouth block filesystems)  

# 8. Install and configure Plymouth theme  
sudo pacman -S plymouth  

cd /tmp  

git clone https://github.com/K-Ivy/Arch-Linux-Gnome-DOTS.git  

sudo cp -r Arch-Linux-Gnome-DOTS/plymouth/catppuccin-frappe-twd \  
       /usr/share/plymouth/themes/catppuccin-frappe-twd  

sudo plymouth-set-default-theme -R catppuccin-frappe-twd  

# 9. Create EFI boot entry and rebuild initramfs  
lsblk  

sudo efibootmgr --create --disk /dev/sda --part 1 \  
  --label "Arch Linux" \  
  --loader /EFI/systemd/systemd-bootx64.efi  

sudo mkinitcpio -P  

bootctl status  

sudo systemctl enable systemd-boot-update.service  

# 10. Reboot into your new system  
reboot  

---
  
</details> 





<details>
<summary>Boot & Connect to Network</summary>
  
</details> 

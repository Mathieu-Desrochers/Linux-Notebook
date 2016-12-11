Configuring the BIOS
--------------------
Change the following settings.

- Date and time: Now as UTC
- Secure Boot Control: Disabled
- Launch CMS: Enabled
- Boot option #1: [P0: SanDisk]

Use the boot override feature and select the DVD.

Salix installation
------------------
Select the following options.

- Keep the current keymap
- Exit the installation

Creating the disk partitions
----------------------------
Run the following commands.

    $ fdisk /dev/sda

    Command (m for help): o
    Command (m for help): n p 1 default +128M
    Command (m for help): n p 2 default +235G
    Command (m for help): n p 3 default +1G
    Command (m for help): a 1
    Command (m for help): t 3 82
    Command (m for help): w

    $ cryptsetup -s 256 -y luksFormat /dev/sda2
    $ cryptsetup luksOpen /dev/sda2 lukssda2
    $ setup

Salix installation
------------------
Pay attention to the following options.

- Partitions editor: Exit
- Select Linux installation partition: /dev/mapper/lukssda2
- Select other Linux partitions: /dev/sda1 at /boot
- Select installation mode: Core
- Install LILO: simple standard MBR
- Network: laptop laptop NetworkManager
- Exit to command line

Configuring the file systems
----------------------------
Edit the following file.

    /mnt/etc/crypttab

Add the following lines.

    lukssda2    /dev/sda2
    lukssda3    /dev/sda3    none    swap

Edit the following file.

    /mnt/etc/fstab

Adjust the following line.

    /dev/mapper/lukssda3   swap   swap   defaults   0   0

Configuring the boot loader
---------------------------
Run the following commands.

    $ mount -o bind /proc /mnt/proc
    $ mount -o bind /sys /mnt/sys
    $ chroot /mnt

    $ mkinitrd -c -k 4.4.19 -m ehci-pci:xhci-hcd:usbhid:hid-generic \
        -f ext4 -r lukssda2 -C /dev/sda2 -L

Edit the following file.

    /etc/lilo.conf

Modify the following setting.

    image = /boot/vmlinuz
      initrd = /boot/initrd.gz
      root = /dev/mapper/cryptroot
      label = linux
      read-only

Run the following command.

    $ lilo

Joining a wireless network
--------------------------
Plugin a network cable.

    $ dhcdcp

Run the following commands.

    $ spi -u
    $ spi -U
    $ spi -i rfkill
    $ spi -i wpa_supplicant

Edit the following file.

    /etc/wpa_supplicant.conf

Add the following lines.

    network={
      ssid="super-network-name"
      psk="super-password"
    }

Run following commands to connect to the wireless network.

    $ ifconfig eth0 down

    $ rfkill unblock wan
    $ wpa_supplicant -Dnl80211 -iwlan0 -c /etc/wpa_supplicant.conf -B
    $ dhcpcd

Installing i3
-------------
Run the following commands.

    $ slapt-get --install-set x
    $ spi -i i3
    $ spi -i i3status
    $ cp /etc/X11/xinit/xinitrc.i3 ~/.xinitrc

Glitches that require manual intervention.

- Comment out the line about /usr/man in i3.Slackbuild
- Make the script executable and run it by hand
- Install the package using installpkg

- Edit the i3 configuration file
- Comment out the content of the bar block

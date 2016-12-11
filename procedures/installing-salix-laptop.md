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

Run the following command then reboot.

    $ lilo

Wireless networking
-------------------
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
      ssid="network-name"
      psk="password"
    }

Run following commands to connect to the wireless network.

    $ ifconfig eth0 down

    $ rfkill unblock wan
    $ wpa_supplicant -Dnl80211 -iwlan0 -c /etc/wpa_supplicant.conf -B
    $ dhcpcd

Configuring the firewall
------------------------
Create the following file.

    /etc/rc.d/rc.firewall

With the following content.  
Where 184.75.221.106 is the address of your VPN.  
All traffic will be forced through there.

    #!/bin/bash
    if [ "$1" = "start" ]
    then
      echo "Applying firewall configuration"

      iptables -F
      iptables -X
      iptables -Z

      iptables -P INPUT DROP
      iptables -P FORWARD DROP
      iptables -P OUTPUT DROP

      iptables -A INPUT -s 184.75.221.106 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
      iptables -A INPUT -p udp --sport 53 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
      iptables -A INPUT -i tun0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
      iptables -A INPUT -i lo -j ACCEPT

      iptables -A OUTPUT -d 184.75.221.106 -j ACCEPT
      iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
      iptables -A OUTPUT -o tun0 -j ACCEPT
      iptables -A OUTPUT -o lo -j ACCEPT

      ip6tables -F
      ip6tables -X
      ip6tables -Z

      ip6tables -P INPUT DROP
      ip6tables -P FORWARD DROP
      ip6tables -P OUTPUT DROP
    fi

Run the following command.

    $ chmod +x /etc/rc.d/rc.firewall

Installing i3
-------------
Run the following commands.

    $ slapt-get --install-set x
    $ spi -i i3
    $ spi -i i3status
    $ cp /etc/X11/xinit/xinitrc.i3 ~/.xinitrc

The following known problems require manual intervention.

- Comment out the line about /usr/man in i3.Slackbuild
- Make the script executable then run it by hand
- Install the package using installpkg
- Edit the i3 configuration file
- Comment out the content of the bar block

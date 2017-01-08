Configuring the BIOS
--------------------
Apply the following settings.

- Date and time: Now as UTC
- Secure Boot: Disabled

Reboot with the USB DVD connected.

Salix installation
------------------
Select the following options.

- Keep the current keymap
- Exit the installation

Creating the disk partitions
----------------------------
Run the following commands.

    $ gdisk /dev/mmcblk0

    Command (? for help): o
    Command (? for help): n 1 default +128M ef00
    Command (? for help): n 2 default +24G default
    Command (? for help): n 3 default +1G 8200
    Command (? for help): w

    $ mkfs.msdos -F 32 /dev/mmcblk0p1
    $ cryptsetup -s 256 -y luksFormat /dev/mmcblk0p2
    $ cryptsetup luksOpen /dev/mmcblk0p2 luksmmcblk0p2
    $ setup

Salix installation
------------------
Pay attention to the following options.

- Partitions editor: Exit
- Select Linux installation partition: /dev/mapper/luksmmcblk0p2
- Select installation mode: Core
- Install LILO: skip
- Network: tombstone tombstone DHCP
- Exit to command line

Configuring the file systems
----------------------------
Edit the following file.

    /mnt/etc/crypttab

Add the following lines.

    luksmmcblk0p2    /dev/mmcblk0p2
    luksmmcblk0p3    /dev/mmcblk0p3    none    swap

Edit the following file.

    /mnt/etc/fstab

Adjust the following line.

    /dev/mapper/luksmmcblk0p3   swap   swap   defaults   0   0

Configuring the boot loader
---------------------------
Run the following commands.

    $ mount -o bind /proc /mnt/proc
    $ mount -o bind /sys /mnt/sys
    $ chroot /mnt

Run the following command to get the modules loaded by the installer.  
Join them with : for the -m option of the next command.

    $ lsmod

Run the following command.

    $ mkinitrd -c -k 4.4.19 -f ext4 -m mmc_core:mmc_block:...
        -r /dev/mapper/luksmmcblk0p2 -C /dev/mmcblk0p2 -L

Edit the following file.

    /usr/sbin/eliloconfig

Hack the following variable assignations.

    EFI_DEVICE="/dev/mmcblk0"
    EFI_PARTITION=1

Run the following command.

    $ mkdir /boot/efi
    $ mount /dev/mmcblk0p1 /boot/efi
    $ eliloconfig

Edit the following file.

    /boot/efi/EFI/Salix-Core-14.2/elilo.conf

Delete the last line.

    append="root=..."

Reboot and pray.

Enabling SSH
------------
Edit the following file.

    /etc/ssh/sshd_config

Set the following options.

    PermitRootLogin no
    PubkeyAuthentication yes
    AuthorizedKeysFile .ssh/authorized_keys
    PasswordAuthentication no
    AllowUsers your-account

Copy your public RSA key to this file.

    /home/your-account/.ssh/authorized_keys

Run the following commands.

    $ chmod +x /etc/rc.d/rc.sshd
    $ /etc/rc.d/rc.sshd start

Configuring the firewall
------------------------
Create the following file.

    /etc/rc.d/rc.firewall

With the following content.

    #!/bin/bash
    if [ "$1" = "start" ]
    then
      echo "Applying firewall configuration"

      iptables -F
      iptables -X
      iptables -Z

      iptables -P INPUT DROP
      iptables -P FORWARD DROP
      iptables -P OUTPUT ACCEPT

      iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
      iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --set
      iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --update --seconds 300 --hitcount 10 -j DROP
      iptables -A INPUT -p tcp --dport 22 -j ACCEPT

      ip6tables -F
      ip6tables -X
      ip6tables -Z

      ip6tables -P INPUT DROP
      ip6tables -P FORWARD DROP
      ip6tables -P OUTPUT DROP
    fi

Run the following command.

    $ chmod +x /etc/rc.d/rc.firewall

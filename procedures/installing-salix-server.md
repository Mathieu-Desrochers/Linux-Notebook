Salix installation
------------------
Select the following options.

- Keep the current keymap
- Exit the installation

Creating the disk partitions
----------------------------
Run the following commands.

    $ fdisk /dev/vda

    Command (m for help): o
    Command (m for help): n p 1 default +128M
    Command (m for help): n p 2 default +235G
    Command (m for help): n p 3 default +1G
    Command (m for help): a 1
    Command (m for help): t 3 82
    Command (m for help): w

    $ cryptsetup -s 256 -y luksFormat /dev/vda2
    $ cryptsetup luksOpen /dev/vda2 luksvda2
    $ setup

Salix installation
------------------
Pay attention to the following options.

- Partitions editor: Exit
- Select Linux installation partition: /dev/mapper/luksvda2
- Select other Linux partitions: /dev/vda1 at /boot
- Select installation mode: Core
- Install LILO: simple standard MBR
- Network: laptop laptop DHCP
- Exit to command line

Configuring the file systems
----------------------------
Edit the following file.

    /mnt/etc/crypttab

Add the following lines.

    luksvda2    /dev/vda2
    luksvda3    /dev/vda3    none    swap

Edit the following file.

    /mnt/etc/fstab

Adjust the following line.

    /dev/mapper/luksvda3   swap   swap   defaults   0   0

Configuring the boot loader
---------------------------
Run the following commands.

    $ mount -o bind /proc /mnt/proc
    $ mount -o bind /sys /mnt/sys
    $ chroot /mnt

    $ mkinitrd -c -k 4.4.19 -f ext4 -r vda2 -C /dev/vda2 -L

Edit the following file.

    /etc/lilo.conf

Set the following options.

    append="quiet vt.default_utf8=1 video=640x480@60"

    disk = /dev/vda bios=0x80 max-partitions=7
    boot = /dev/vda

    image = /boot/vmlinuz
      initrd = /boot/initrd.gz
      root = /dev/mapper/luksvda2
      label = Salix
      read-only

Run the following command then reboot.

    $ lilo

Configuring the keyboard
------------------------
Edit the following file.

    /etc/inputrc

Modify the following lines.

    # Set various nice escape sequences:
    "\e[1;5C": forward-word
    "\e[1;5D": backward-word

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
      iptables -A INPUT -p tcp --dport 443 -j ACCEPT

      ip6tables -F
      ip6tables -X
      ip6tables -Z

      ip6tables -P INPUT DROP
      ip6tables -P FORWARD DROP
      ip6tables -P OUTPUT DROP
    fi

Run the following command.

    $ chmod +x /etc/rc.d/rc.firewall

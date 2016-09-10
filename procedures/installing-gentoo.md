Preparation
-----------
Hook to the network using a cable.  
Boot from the minimal installation cd.  
Confirm the network is up with the following command.

    $ ping www.gentoo.org

Creating the disk partitions
----------------------------
Run the following commands.

    $ parted -a optimal /dev/sda

    (parted) mklabel gpt
    (parted) unit mib

    (parted) mkpart primary 1 3
    (parted) name 1 grub
    (parted) set 1 bios_grub on

    (parted) mkpart primary 3 131
    (parted) name 2 boot
    (parted) set 2 boot on

    (parted) mkpart primary 131 643
    (parted) name 3 swap

    (parted) mkpart primary 643 -1
    (parted) name 4 root

    (parted) quit

Creating the file systems
-------------------------
Run the following commands.  
Safely ignore errors about busy devices.

    $ mkfs.ext4 /dev/sda2

    $ cryptsetup create -d /dev/urandom swap /dev/sd3
    $ mkswap /dev/mapper/swap
    $ swapon /dev/mapper/swap

    $ cryptsetup luksFormat /dev/sda4
    $ cryptsetup luksOpen /dev/sda4 root
    $ mkfs.ext4 /dev/mapper/root

Mounting the disks
------------------
Run the following commands.

    $ mount /dev/mapper/root /mnt/gentoo
    $ mkdir /mnt/gentoo/boot
    $ mount /dev/sda2 /mnt/gentoo/boot

Downloading the stage3 archive
------------------------------
Run the following commands.

    $ cd /mnt/gentoo
    $ links http://mirror.csclub.uwaterloo.ca/gentoo-distfiles/
        releases/amd64/autobuilds/current-stage3-amd64/

Select the following file and press D.

    stage3-amd64-*.tar.bz2

Run the following command.

    $ tar -xjpf stage3-amd64-*.tar.bz2 --xattrs

Selecting the packages mirror
-----------------------------
Run the following command.

    $ mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf

Select the following mirror.

    http://mirror.csclub.uwaterloo.ca/gentoo-distfiles/

Setting the compile options
---------------------------
Edit the following file.

    /mnt/gentoo/etc/portage/make.conf

Set the following variables.  
Use the number of cores plus one for parallel builds.

    CFLAGS="-march=native -O2 -pipe"
    MAKEOPTS="-j5"

Add the following flags to play videos on a desktop computer.

    CPU_FLAGS_X86="mmx mmxext sse sse2 sse3"

Switching to the installed root
-------------------------------
Run the following commands.

    $ cp -L /etc/resolv.conf /mnt/gentoo/etc/

    $ mount -t proc proc /mnt/gentoo/proc
    $ mount --rbind /sys /mnt/gentoo/sys
    $ mount --rbind /dev /mnt/gentoo/dev

    $ chroot /mnt/gentoo
    $ source /etc/profile
    $ export PS1="(chroot) $PS1"

Updating the packages
---------------------
Run the following commands.

    $ emerge-webrsync
    $ eselect profile list
    $ eselect profile set X

Where X should be the number one of these.

- Server: default/linux/amd64/13.0
- Desktop: default/linux/amd64/13.0/desktop

Run the following commands.

    $ emerge --ask --update --deep --newuse @world

You probably deserved a long nap. Take it now.

Configuration
-------------
Run the following commands.

    $ echo 'Canada/Eastern' > /etc/timezone
    $ emerge --config sys-libs/timezone-data

Edit the following file.

    /etc/locale.gen

Uncomment the following lines.

    en_US ISO-8859-1
    en_US.UTF-8 UTF-8

Run the following commands.

    $ locale-gen
    $ eselect locale list
    $ eselect locale set X

Where X is the number for en_US.utf8.  
Run the following commands.

    $ env-update
    $ source /etc/profile
    $ export PS1="(chroot) $PS1"

Declaring the file systems
--------------------------
Edit the following file.

    /etc/fstab

Set the following content.

    /dev/sda2           /boot         ext4    noauto,noatime    0 2
    /dev/mapper/root    /             ext4    noatime           0 1
    /dev/mapper/swap    none          swap    sw                0 0
    /dev/cdrom          /mnt/cdrom    auto    noauto            0 0
    /dev/usb            /mnt/usb      auto    noauto            0 0

Setting up system logging
-------------------------
Run the following commands.

    $ emerge --ask app-admin/sysklogd
    $ emerge --ask app-admin/logrotate
    $ emerge --ask app-admin/dcron

    $ rc-update add sysklogd default
    $ rc-update add dcron default

Setting up the network
----------------------
See one of the following procedures.

- [Laptop](installing-gentoo-laptop-network.md)
- [Server](installing-gentoo-server-network.md)

Building the kernel
-------------------
Run the following commands.

    $ emerge --ask sys-kernel/gentoo-sources
    $ cd /usr/src/linux
    $ make menuconfig

See one of the following set of options.

- [Laptop](installing-gentoo-laptop-kernel.md)
- [Server](installing-gentoo-server-kernel.md)

Run the following commands.

    $ make -j5 && make modules_install
    $ make install

Setting up the bootloader
-------------------------
Run the following commands.

    $ emerge --ask sys-fs/cryptsetup
    $ emerge --ask sys-fs/lvm2
    $ emerge --ask sys-kernel/genkernel

For a desktop computer run the following command.

    $ genkernel --luks --lvm initramfs

For a server run the following command.

    $ genkernel --luks --lvm --virtio initramfs

Run the following commands.

    $ emerge --ask sys-boot/grub:2
    $ grub-install /dev/sda
    $ ls -l /dev/disk/by-uuid

Note the GUID of /dev/sda4.  
Edit the following file.

    /etc/default/grub

Modify the following variables.

    GRUB_CMDLINE_LINUX="crypt_root=UUID=<GUID> root=/dev/mapper/root"

Run the following command.

    $ grub-mkconfig -o /boot/grub/grub.cfg

Final steps
-----------
Run the following commands.

    $ rm stage3-amd64-*.tar.bz2
    $ passwd

Reboot and pray.

Setting up a firewall
---------------------
See one of the following procedures.

- [Laptop](installing-gentoo-laptop-firewall.md)
- [Server](installing-gentoo-server-firewall.md)

Configuring SSH
---------------
Edit the following file.

    /etc/ssh/sshd_config

Set the following options.

    PermitRootLogin no
    AuthorizedKeysFile .ssh/authorized_keys
    PasswordAuthentication no
    UsePAM no
    AllowUsers my-account

Run the following command.

    $ sudo /etc/init.d/ssh restart

Configuring a web server
------------------------

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
    $ links http://mirror.csclub.uwaterloo.ca/gentoo-distfiles/current-stage3-amd64/

Select the following file and press D.

    stage3-amd64-*.tar.bz2

Run the following command.

    $ tar -xjpf stage3-amd64-*.tar.bz2

Selecting the packages mirror
-----------------------------
Run the following command.

    $ mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf

Setting the compile options
---------------------------
Edit the following file.

    /mnt/gentoo/etc/portage/make.conf

Modify the following variables.

    CFLAGS="-march=native -O2 -pipe"
    MAKEOPTS="-j5"
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

Where X is the number for default/linux/amd64/13.0/desktop.  
Run the following commands.

    $ emerge --ask --update --deep --newuse @world

You deserved a long nap. Take it now.

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

    $ emerge --ask app-admin/sysklog
    $ emerge --ask app-admin/logrotate
    $ emerge --ask app-admin/dcron

    $ rc-update add sysklog default
    $ rc-update add dcron default

Setting up the network
----------------------
Run the following commands.

    $ ln -s /etc/init.d/net.lo /etc/init.d/net.enp2s0
    $ ln -s /etc/init.d/net.lo /etc/init.d/net.wlp1s0

Edit the following file.

    /etc/conf.d/hostname

Modify the following variable.

    hostname="laptop"

Edit the following file.

    /etc/issue

Set the following content.

    This is \n (\s \m \r) \t

Run the following commands.

    $ emerge --ask net-misc/dhcpcd
    $ emerge --ask net-wireless/wpa_supplicant

Edit the following file.

    /etc/wpa_supplicant/wpa_supplicant.conf

Set the following content.

    ctrl_interface=/var/run/wpa_supplicant
    eapol_version=1
    ap_scan=1

    network={
      ssid=""
      psk=""
    }

Building the kernel
-------------------
Run the following commands.

    $ emerge --ask sys-kernel/gentoo-sources
    $ cd /usr/src/linux
    $ make menuconfig

Select the following options.

    Processor type and features
      Processor family
        (X) Core 2/Newer Xeon

    Device drivers
      Multiple devices driver support (RAID and LVM)
        Device mapper support
          <*> Crypt target support
      Network device support
        Network core driver support
          <*> Universal TUN/TAP device driver support
        Ethernet driver support
          [*] Realtek devices
            <M> Realtek 8169 gigabit ethernet support
        Wireless LAN
          <M> Atheros Wireless Cards
            <M> Atheros 802.11n wireless cards support
              [*] Atheros ath9k PCI/PCIe bus support

    Cryptographic API
      <*> XTS support
      <*> AES cipher algorithms (x86_64)

Run the following commands.

    $ make -j5 && make modules_install
    $ make install

Setting up the bootloader
-------------------------
Run the following commands.

    $ emerge --ask sys-fs/cryptsetup
    $ emerge --ask sys-fs/lvm2
    $ emerge --ask sys-kernel/genkernel

    $ genkernel --luks --lvm initramfs

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

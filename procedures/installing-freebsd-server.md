FreeBSD installation
--------------------
Select the following options.

- Boot Multi User
- Install
- Continue with default keymap
- Optional system components: Defaults
- Partitioning: Shell

Full Disk Encryption
--------------------
Create the MBR slice.

    # gpart create -s mbr vtbd0
    # gpart bootcode -b /boot/mbr vtbd0
    # gpart add -t freebsd vtbd0
    # gpart set -a active -i 1 vtbd0

Create the partitions.

    # gpart create -s bsd vtbd0s1
    # gpart bootcode -b /boot/boot vtbd0s1

    # gpart add -t freebsd-swap -s 1G -a 1M /dev/vtbd0s1
    # gpart add -t freebsd-ufs -s 1G -a 1M /dev/vtbd0s1
    # gpart add -t freebsd-ufs -a 1M /dev/ada0s1

Create the boot file system.

    # newfs -S 4096 /dev/vtbd0s1b

Create the GELI file system.

    # geli init -e AES-XTS -l 128 -s 4096 -b /dev/vtbd0s1d
    # geli attach /dev/vtbd0s1d
    # newfs -S 4096 /dev/vtbd0s1d.eli

Fool the installer into installing where we want.

    # mount /dev/vtbd0s1d.eli /mnt
    # mkdir /mnt/bootfs
    # mount /dev/vtbd0s1b /mnt/bootfs
    # mkdir /mnt/bootfs/boot
    # ln -s /mnt/bootfs/boot /mnt/boot

Create the following file.

    /tmp/bsdinstall_etc/fstab

With the following content.

    /dev/vtbd0s1a.eli  none  swap  sw,ealgo=AES-XTS,keylen=128,sectorsize=4096 0 0
    /dev/vtbd0s1d.eli  /     ufs   rw 1 1

Create the following file.

    /tmp/bsdinstall_boot/loader.conf

With the following content.

    geom_eli_load="YES"
    vfs.root.mountfrom="ufs:vtbd0s1d.eli"

Run the following commands.

    exit

Network Configuration
---------------------
Select the following options.

- IPV4: Yes
- DHCP: Yes
- IPV6: No

Date and Time
-------------
Select the following options.

- America - Canada - Eastern ON, QC - EDT
- Set date and time: Skip

System Configuration
--------------------
Select the following options.

- ntpd
- dumpdev

System Hardening
----------------
Select all the options.

Add Users
---------
Select the following options.

- Groups: wheel

FreeBSD installation
--------------------
Select the following options.

- Boot Multi User
- Install
- Continue with default keymap
- Optional system components: lib32, ports
- Partitioning: Shell

Partitioning
------------
Create the GTP boot partition.

    # gpart create -s GPT vtbd0
    # gpart add -t freebsd-boot -s 512K vtbd0
    # gpart bootcode -b /boot/pmbr -p /boot/gptboot -i 1 vtbd0

Create the boot partition.

    # gpart add -t freebsd-ufs -s 2G vtbd0
    # newfs -U /dev/vtbd0p2

Create the encrypted root partition.

    # gpart add -t freebsd-ufs -s 2G vtbd0
    # geli init -b -s 4096 /dev/vtbd0p3
    # geli attach /dev/vtbd0p3
    # newfs -U /dev/vtbd0p3.eli

Create the encrypted home partition.

    # gpart add -t freebsd-ufs -s 2G vtbd0
    # geli init -s 4096 /dev/vtbd0p4
    # geli attach /dev/vtbd0p4
    # newfs -U /dev/vtbd0p4.eli

Create the encrypted var partition.

    # gpart add -t freebsd-ufs -s 18G vtbd0
    # geli init -s 4096 /dev/vtbd0p5
    # geli attach /dev/vtbd0p5
    # newfs -U /dev/vtbd0p5.eli

Create the swap partition.

    # gpart add -t freebsd-swap vtbd0

Mount the encrypted root partition.
This is where the installer will copy files.

    # mount /dev/vtbd0p3.eli /mnt
    # mkdir /mnt/home

Mount the boot partition.
This is where the installer will copy the boot files.

    # mkdir /tmp/bootfs
    # mount /dev/vtbd0p2 /tmp/bootfs
    # mkdir /tmp/bootfs/boot
    # ln -s /tmp/bootfs/boot /mnt/boot

Create the following file.

    /tmp/bsdinstall_boot/loader.conf

With the following content.

    geom_eli_load="YES"
    vfs.root.mountfrom="ufs:vtbd0p3.eli"

Create the following file.

    /tmp/bsdinstall_etc/fstab

With the following content.

    /dev/vtbd0p3.eli /     ufs  rw 0 0
    /dev/vtbd0p4.eli /home ufs  rw 1 1
    /dev/vtbd0p5.eli /var  ufs  rw 1 1
    /dev/vtbd0p6.eli none  swap sw 0 0

Network Configuration
---------------------
Cancel.

Date and Time
-------------
Select the following options.

- America - Canada - Eastern ON, QC - EDT
- Set date and time: Skip

System Configuration
--------------------
Unselect all the services.

System Hardening
----------------
Select all the options.

Live CD
-------
Detach the encrypted partitions.

    # geli detach /dev/vtbd0p3.eli
    # geli detach /dev/vtbd0p4.eli
    # geli detach /dev/vtbd0p5.eli

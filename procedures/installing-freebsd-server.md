FreeBSD installation
--------------------
Select the following options.

- Boot Multi User
- Install
- Continue with default keymap
- Optional system components: lib32, ports
- Partitioning: Shell

Full Disk Encryption
--------------------
Create the GTP boot partition.

    # gpart create -s GPT vtbd0
    # gpart add -t freebsd-boot -s 512K vtbd0
    # gpart bootcode -b /boot/pmbr -p /boot/gptboot -i 1 vtbd0

Create the FreeBSD boot partition.

    # gpart add -t freebsd-ufs -s 1G vtbd0
    # newfs -U /dev/vtbd0p2

Create the FreeBSD encrypted root partition.

    # gpart add -t freebsd-ufs -s 23G vtbd0
    # geli init -b -s 4096 /dev/vtbd0p3
    # geli attach /dev/vtbd0p3
    # dd if=/dev/random of=/dev/vtbd0p3.eli bs=1m
    # newfs -U /dev/vtbd0p3.eli

Mount the FreeBSD encrypted root partition.
This is where the installer will copy files.

    # mount /dev/vtbd0p3.eli /mnt

Mount the FreeBSD boot partition.
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

    /dev/vtbd0p3.eli / ufs rw 1 1

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
Unselect all the services.

System Hardening
----------------
Select all the options.

FreeBSD installation
--------------------
Select the following options.

- Boot Multi User
- Install
- Continue with default keymap
- Optional system components: lib32, ports
- Partitioning: Shell

Encrypted partitions
--------------------
Create the GTP boot partition.

    # gpart create -s GPT vtbd0
    # gpart add -t freebsd-boot -s 512K vtbd0
    # gpart bootcode -b /boot/pmbr -p /boot/gptboot -i 1 vtbd0

Create the boot partition.

    # gpart add -t freebsd-ufs -s 2G vtbd0
    # newfs -U /dev/vtbd0p2

Create the encrypted root partition.

    # gpart add -t freebsd-ufs -s 100G vtbd0
    # geli init -b -s 4096 /dev/vtbd0p3
    # geli attach /dev/vtbd0p3
    # newfs -U /dev/vtbd0p3.eli

Create the encrypted swap partition.

    # gpart add -t freebsd-swap -s 1G vtbd0

Mount the encrypted partitions.  
This is where the installer will copy files.

    # mount /dev/vtbd0p3.eli /mnt

Mount the boot partition.  
This is where the installer will copy the boot files.

    # mkdir /tmp/vtbd0p2
    # mount /dev/vtbd0p2 /tmp/vtbd0p2
    # mkdir /tmp/vtbd0p2/boot
    # ln -s /tmp/vtbd0p2/boot /mnt/boot

Create the following file.

    /tmp/bsdinstall_boot/loader.conf

With the following content.

    geom_eli_load="YES"
    vfs.root.mountfrom="ufs:vtbd0p3.eli"

Create the following file.

    /tmp/bsdinstall_etc/fstab

With the following content.

    /dev/vtbd0p2     /mnt/vtbd0p2 ufs   rw           0 2
    /dev/vtbd0p3.eli /            ufs   rw           0 1
    /dev/vtbd0p4.eli none         swap  sw           0 0

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

First boot
----------
Remove the CD, reboot and select Boot Single User.  
Run the following commands.

    # rm /boot
    # mkdir -p /mnt/vtbd0p2
    # mount /dev/vtbd0p2 /mnt/vtbd0p2
    # ln -s /mnt/vtbd0p2/boot /boot

Securely joining the network
----------------------------
Run the following commands.

    # sysrc pf_enable=YES
    # sysrc blacklistd_enable=YES

Create the following file.

    /etc/pf.conf

With the following content.

    set skip on lo0
    scrub in

    anchor "blacklistd/*" in

    block in
    pass out

    pass in proto tcp from any to port 22

Create the following file.

    /etc/blacklistd.conf

With the following content.

    [local]
    ssh * * * * 3 24h

Edit the following file.

    /etc/rc.conf

Add the following line.

    ifconfig_vtnet0="DHCP"

Reboot.

Enabling remote access
----------------------
Edit the following file.

    /etc/ssh/sshd_config

Set the following options.

    PermitRootLogin no
    PubkeyAuthentication yes
    AuthorizedKeysFile .ssh/authorized_keys
    PasswordAuthentication no
    UseBlacklist yes
    AllowUsers your-username

Edit the following file.

    /etc/rc.conf

Add the following line.

    sshd_enable="YES"

Installing a graphical desktop
------------------------------
Run the following commands.

    # pkg install drm-kmod
    # sysrc kld_list+="/boot/modules/i915kms.ko"
    # pw groupmod video -m your-user

Run the following commands.

    # pkg install xorg

Run the following commands.  
Pay attention to the output about xorg.conf.

    # pkg install urwfonts
    # pkg install terminus-font

Run the following commands.

    # pkg install i3
    # pkg install i3status
    # pkg install dmenu

Enabling wireless networking
----------------------------
Plug in your nifty EW-7811Un.  
Edit the following file.

    /boot/loader.conf

Add the following options.

    if_urtwn_load="YES"
    legal.realtek.license_ack=1

Reboot.

Forcing traffic through a VPN
-----------------------------
Edit the following file.

    /boot/loader.conf

Add the following options.

    if_tun="YES"

Download the .ovpn file of your choice from your provider.  
Copy it in the following location.

    /usr/local/etc/openvpn.conf

Apply the following change to the file.

    ---- auth-user-pass
    ++++ auth-user-pass /home/your-name/.vpn

    ++++ daemon

Create the following file.

    /home/your-name/.vpn

With the following content.

    username
    password

Edit the following file.

    /etc/resolv.conf

List only the DNS servers of your provider.

    nameserver 103.86.99.100
    nameserver 103.86.99.100

Lock things up with the following command.

    chflags schg /etc/resolv.conf

Edit the following file.

    /etc/pf.conf

Set the following outbound rules.  
Use the DNS servers and IP address of your provider.

    block out all
    pass out on wlan0 proto {tcp udp} from any to {103.86.99.100 103.86.99.100} port 53
    pass out on wlan0 proto {tcp udp} from any to 67.215.14.197
    pass out on tun0 all

Installing slackware 14.1 on my laptop
======================================

Selecting the packages to install
---------------------------------
Select the following packages:

    A  - Base Linux System
         Everything

    AP - Various Applications that do not need X
         groff
         man
         man-pages

    F -  FAQ lists,  HOWTO documentation
         Everything

    L -  System Libraries (Needed by KDE, GNOME, X, and more)
         dbus-glib
         dbus-python
         glib2
         libffi
         libnl3
         pygobject
         urwid

    N -  Networking (TCP/IP, UUCP, Mail, News)
         dhcpcd
         iputils
         net-toolsdf 
         network-scripts
         wireless-tools
         wpa-supplicant

Configuring the boot loader
---------------------------
Run the following commands:

    # vi /etc/lilo.conf

Perform the following edits:

- Comment the section named Boot BMP Image
- Uncomment the section named Standard menu

Perform the following edits:

    append="logo.nologo vt.default_uft8=1"
    compact
    # prompt
    vga=791

Run the following commands:

    # lilo

Enabling the DVD drive
----------------------
Run the following commands:

    # vi /etc/fstab

Perform the following edits:

- Uncomment the line starting with /dev/cdrom

Then run the following commands to mount the DVD drive:

    # mount /dev/cdrom
    # cd /mnt/cdrom

Enabling wireless networking
----------------------------
Run the following commands:

    # vi /etc/rc.d/rc.inet1.conf

Perform the following edits:

    IPADDR[0]=""
    NETMASK[0]=""
    USE_DHCP[0]=""
    DHCP_HOSTNAME[0]=""
    GATEWAY[0]=""

Run the following commands:

    # installpkg /mnt/cdrom/extra/wicd/wicd-1.7.2.4-x86_64-4.txz

Run the following commands to disable automatic networking:

    # chmod -x /etc/rc.d/rc.wicd

Then run the following commands to connect to a network:

    # wicd
    # wicd-curses

Displaying UTF-8 characters
---------------------------
Run the following commands:

    # vi /etc/profile.d/lang.sh

Perform the following edits:

    # export LANG=en_US
    export LANG=en_US.UTF-8

Run the following commands:

    # installpkg /mnt/cdrom/slackware64/ap/terminus-font-4.38-noarch-1.txz

Run the following commands:

    # echo "setfont ter-v18n" > ~/.bash_profile

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
         libnl3
         urwid

    N -  Networking (TCP/IP, UUCP, Mail, News)
         dhcpcd
         iputils
         libnl3
         network-scripts
         net-toolsdf 
         wireless-tools
         wpa-supplicant

Booting strait to slackware
---------------------------
Run the following commands:

    # vi /etc/lilo.conf

Perform the following edits:

- Comment the section named Boot BMP Image
- Uncomment the section named Standard menu
- Comment the line containing prompt

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

    # installpkg /mnt/cdrom/extra/wicd/wicd-1.7.2.4-x86_64-4.txz

Run the following commands to disable automatic networking:

    # chmod -x /etc/rc.d/rc.wicd

Then run the following commands to connect to a network:

    # wicd
    # wicd-curses

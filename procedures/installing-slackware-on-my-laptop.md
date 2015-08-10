Installing slackware 14.1 on my laptop
======================================

Selecting the packages to install
---------------------------------
Select the following series:

- A - Base Linux System
- AP - Various Applications that do not need X
- D - Program Development (C, C++, Lisp, Perl, etc.)
- F - FAQ lists,  HOWTO documentation
- L - System Libraries (Needed by KDE, GNOME, X, and more)
- N - Networking (TCP/IP, UUCP, Mail, News)
- TCL - Tlc/Tk script languages

Booting strait to slackware
---------------------------
Run the following commands:

    # vim /etc/lilo.conf

Perform the following edits:

- Comment the section named Boot BMP Image
- Uncomment the section named Standard menu
- Comment the line containing prompt

Run the following commands:

    # lilo

Making the DVD drive mountable
------------------------------
Run the following commands:

    # vim /etc/fstab

Perform the following edits:

- Uncomment the line starting with /dev/cdrom

Then run the following commands to mount the DVD drive:

    # mount /dev/cdrom
    # cd /mnt/cdrom

Enabling wireless networking
----------------------------
Run the following commands:

    # vim /etc/rc.d/rc.inet1.conf

Edit the following lines:

    IPADDR[0]=""
    NETMASK[0]=""
    USE_DHCP[0]=""
    DHCP_HOSTNAME[0]=""
    GATEWAY=""

Run the following commands:

    # installpkg /mnt/cdrom/extra/wicd/wicd-1.7.2.4-x86_64-4.txz
    # chmod +x /etc/rc.d/rc.wicd

Run the following commands:

    # vim /etc/rc.d/rc.local

Add the following lines:

    if [ -x /etc/rc.d/rc.wid ]; then
      /etc/rc.d/rc.wid start
    fi

Then run the following commands to connect to a network:

    # wicd-curses

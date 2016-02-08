Imaging the SD card
-------------------
Connect the card to your computer.  
Run the following command to locate its device name.

    $ df -h
    ...
    /dev/sdx0       1.3G  831M  362M  70% /media/xxx
    ...

Get the one mounted under media, where x is a letter and 0 a number.  
Double check the device size just to make sure.

Run the following commands.

    $ umount /dev/sdx0
    $ sudo dd bs=4M if=2015-11-21-raspbian-jessie-lite.img of=/dev/sdx
    $ sync

Insert the card into the pi and connect its network cable.  
Time for a first boot.

Figuring out the pi's IP address
--------------------------------
Still connected to your computer, run the following command.

    $ ip addr
    ...
    3: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    ...

Locate the name of your connected network interface.  
Run the following command.

    $ sudo arp-scan --interface=wlan0 --localnet
    ...
    192.168.1.102   b8:27:eb:cb:c2:cf       (Unknown)
    ...

Get the IP address on the line showing b8:27.  
This is the pi's address on your network.

Connecting to the pi
--------------------
Run the following commands.

    $ ssh pi@192.168.1.102
    password: raspberry

    $ adduser mathieu
    $ adduser mathieu sudo

    $ exit

Now reconnect as yourself and run the following commands.

    $ ssh mathieu@192.168.1.102

    $ sudo deluser -remove-home pi
    $ sudo groupdel pi

Upgrading the OS
----------------
Run the following commands.

    $ sudo apt-get update
    $ sudo apt-get upgrade

Basic configuration
-------------------
Run the following commands.

    $ sudo hostnamectl set-hostname tombstone
    $ dpkg-reconfigure tzdata

Downloading the raspbian image
------------------------------
Get the latest raspbian lite image from the following site.

    https://www.raspberrypi.org/downloads/

Imaging the micro SD card
-------------------------
Connect the card to your computer.  
Run the following command to locate its device name.

    $ df -h
    ...
    /dev/sdX0       1.3G  831M  362M  70% /media/xxx
    ...

Note the one mounted under media, where X is a letter and 0 is a number.  
Double check the device size to make sure.

Run the following commands.

    $ umount /dev/sdX0
    $ sudo dd bs=4M if=2015-11-21-raspbian-jessie-lite.img of=/dev/sdX
    $ sync

Insert the card into the pi and connect its network cable.  
Time for a first boot.

Figuring out the pi's IP address
--------------------------------
Run the following command from your laptop.

    $ ip addr
    ...
    3: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    ...

Note the name of your connected network interface.  
Run the following command.

    $ sudo arp-scan --interface=wlan0 --localnet
    ...
    192.168.1.102   b8:27:eb:cb:c2:cf       (Unknown)
    ...

Note the IP address for the MAC address starting with b8:27.  
This is the pi's current address on your network.

Connecting to the pi
--------------------
Run the following commands.

    $ ssh pi@192.168.1.102
    password: raspberry

    $ sudo adduser your-name
    $ sudo adduser your-name sudo
    $ exit

Reconnect as yourself and run the following commands.

    $ ssh your-name@192.168.1.102
    $ sudo deluser -remove-home pi

Basic setup
-----------
Run the following commands.

    $ sudo apt-get update
    $ sudo apt-get upgrade

    $ sudo hostnamectl set-hostname tombstone
    $ sudo dpkg-reconfigure tzdata

Configuring SSH
---------------
Run the following command from your laptop.  
Do so from a folder containing your public key.

    $ rcp id_rsa.pub your-name@192.168.1.102:id_rsa.pub

Run the following commands on the server.

    $ mkdir .ssh
    $ mv ~/id_rsa.pub .ssh/authorized_keys
    $ chmod 600 .ssh/authorized_keys

Edit the following file on the server.

    /etc/ssh/sshd_config

Apply the following changes.

    ---- PermitRootLogin without-password
    ++++ PermitRootLogin no
    ++++ AllowUsers your-name

    ---- #AuthorizedKeysFile      %h/.ssh/authorized_keys
    ++++ AuthorizedKeysFile      %h/.ssh/authorized_keys

    ---- #PasswordAuthentication yes
    ++++ PasswordAuthentication no

Run the following command on the server.

    $ sudo /etc/init.d/ssh restart

Run the following commands from your laptop.  
Do so from a folder containing your private key.

    $ cp id_rsa ~/.ssh
    $ chmod 600 ~/.ssh/id_rsa

Reconnect to the server without a password.

Setting up a firewall
---------------------
Run the following command to install the firewall.

    $ sudo apt-get install ufw

Edit the following file and set IPV6=no.

    /etc/default/ufw

Run the following commands.

    $ sudo ufw default allow outgoing
    $ sudo ufw default deny incoming
    $ sudo ufw allow 22/tcp
    $ sudo ufw enable

Setting up a login throttler
----------------------------
Run the following command.

    $ sudo apt-get install fail2ban
    $ sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

Edit the following file.

    /etc/fail2ban/jail.local

Replace its content with the following lines.  
It won't monitor any service for now.

    [DEFAULT]
    bantime  = 600  ; 10 minutes
    findtime = 600  ; 10 minutes
    maxretry = 3

    [recidive]
    enabled  = true
    filter   = recidive
    logpath  = /var/log/fail2ban.log
    action   = iptables-allports[name=recidive]
    bantime  = 604800  ; 1 week
    findtime = 86400   ; 1 day

Run the following command.

    $ sudo fail2ban-client reload

Setting up a mail server
------------------------
Create a MX record pointing to your server.  
This can be confirmed with the following command.

    $ dig MX your-domain.com +short
    50 your-domain.com

Run the following commands.

    $ sudo apt-get install postfix
    $ sudo postfix stop

Answer the following when prompted.

- Internet Site
- your-domain.com

Edit the following file.

    /etc/postfix/main.cf

Replace its content with the following lines.

    mydomain = your-domain.com
    myorigin = $mydomain
    mydestination = $mydomain
    mynetworks_style = host
    relay_domains =

    smtpd_helo_restrictions = reject_unknown_helo_hostname
    smtpd_sender_restrictions = reject_unknown_sender_domain
    smtpd_relay_restrictions = reject_unauth_destination
    smtpd_recipient_restrictions = reject_unauth_destination
    smtpd_data_restrictions = reject_unauth_pipelining

    relayhost = some-relay.your-provider.com

    home_mailbox = Maildir/

Edit the following file.

    /etc/aliases

Define the following aliases.

    postmaster: your-name
    mail: your-name
    root: your-name

Run the following commands.

    $ sudo ufw allow 25/tcp

Edit the following file.

    /etc/fail2ban/jail.local

Append the following lines.

    [postfix]
    enabled  = true
    port     = 25
    filter   = postfix
    logpath  = /var/log/mail.log

Run the following command.

    $ sudo fail2ban-client reload
    $ sudo newaliases
    $ sudo postfix start
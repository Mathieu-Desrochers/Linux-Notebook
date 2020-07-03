Requirements
------------
You will need the following.

    - 1 Raspberry PI
    - 1 SD card
    - 1 static IP address (ask your ISP)
    - 2 drops of dedication

Imaging the micro SD card
-------------------------
Get the latest raspbian lite image from the following site.

    https://www.raspberrypi.org/downloads/

Connect the SD card to your computer.  
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

Insert the SD card into the pi and connect its network cable.  
Time for a first boot.

Figuring out the pi's address
-----------------------------
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

Resizing the file system
------------------------
Run the following command.

    $ sudo fdisk /dev/mmcblk0

Type the command p.

    Device         Boot  Start     End Sectors  Size Id Type
    /dev/mmcblk0p1        8192  131071  122880   60M  c W95 FAT32 (LBA)
    /dev/mmcblk0p2      131072 2848767 2717696  1.3G 83 Linux

Note the start of the Linux partition.  
Type the following commands.

    - d
    - 2
    - n
    - p
    - 2
    - 131072
    - enter
    - w

Run the following commands.

    $ sudo shutdown --reboot now
    $ sudo resize2fs /dev/mmcblk0p2

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

    $ scp id_rsa.pub your-name@192.168.1.102:id_rsa.pub

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
    $ sudo ufw limit 22/tcp
    $ sudo ufw enable

Preventing brute force logins
-----------------------------
Edit the following file.

    /etc/pam.d/common-auth

Add the following line at the beginning of the file.

    ++++ auth  required  pam_tally2.so file=/var/log/tallylog deny=3 even_deny_root unlock_time=300

Edit the following file.

    /etc/pam.d/common-account

Add the following line at the beginning of the file.

    ++++ account  required  pam_tally2.so

Run the following command.

    $ sudo /etc/init.d/ssh restart

Blacklisting script kiddies from china
--------------------------------------
Run the following command.

    sudo apt-get install libpam-geoip

Edit the following file.

    /etc/security/geoip.conf

Set the following configuration.

    #<domain>       <service>       <action>        <location>
    *               sshd            allow           CA, *
    *               sshd            allow           UNKNOWN
    *               sshd            deny            *
    *               *               allow           *

Download the GeoIP database from the following site.

    http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz

Edit the following file.

    /etc/pam.d/common-account

Add the following line at the beginning of the file.

    ++++ account  required  pam_geoip.so  geoip_db=/etc/security/geoip.dat

Run the following command.

    $ sudo /etc/init.d/ssh restart

Generating a self signed SSL certificate
----------------------------------------
Run the following commands.

    $ sudo openssl req -x509 -nodes -days 3650 -newkey rsa:2048
        -keyout /etc/ssl/private/mail.key
        -out /etc/ssl/certs/mailcert.pem

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

    compatibility_level = 2

    myhostname = your-domain.com
    mydomain = your-domain.com
    myorigin = $mydomain
    mydestination = $mydomain
    mynetworks_style = host
    relay_domains =

    smtpd_relay_restrictions = reject_unauth_destination
    smtpd_recipient_restrictions = reject_unauth_destination

    smtp_tls_security_level = may
    smtpd_tls_security_level = may
    smtpd_tls_cert_file = /etc/ssl/certs/mailcert.pem
    smtpd_tls_key_file = /etc/ssl/private/mail.key

    home_mailbox = Maildir/

Edit the following file.

    /etc/aliases

Define the following aliases.

    mail: your-user

Run the following commands.

    $ sudo ufw limit 25/tcp

Run the following command.

    $ sudo newaliases
    $ sudo postfix start

Using the mail server remotely
------------------------------
Run the following command.

    $ sudo apt-get install dovecot-core dovecot-imapd

Edit the following file.

    /etc/dovecot/dovecot.conf

Replace its content with the following lines.

    protocols = imap

    service imap-login {
      inet_listener imap {
        port = 0
      }
    }

    userdb {
      driver = passwd
    }

    passdb {
      driver = pam
      args = dovecot
    }

    ssl = required
    ssl_cert = </etc/ssl/certs/mailcert.pem
    ssl_key = </etc/ssl/private/mail.key
    auth_mechanisms = plain

    mail_location = maildir:~/Maildir

    service auth {
      unix_listener /var/spool/postfix/private/auth {
        mode = 0660
        user = postfix
        group = postfix
      }
    }

Edit the following file.

    /etc/postfix/main.cf

Apply the following changes.

    ---- smtpd_relay_restrictions = reject_unauth_destination
    ++++ smtpd_relay_restrictions = permit_sasl_authenticated, reject_unauth_destination

    ---- smtpd_recipient_restrictions = reject_unauth_destination
    ++++ smtpd_recipient_restrictions = permit_sasl_authenticated, reject_unauth_destination

    ++++ smtpd_sasl_auth_enable = yes
    ++++ smtpd_sasl_type = dovecot
    ++++ smtpd_sasl_path = private/auth

Edit the following file.

    /etc/postfix/master.cf

Apply the following changes.

    ---- #submission inet n       -       -       -       -       smtpd
    ---- #  -o syslog_name=postfix/submission

    ++++ submission inet n       -       -       -       -       smtpd
    ++++   -o syslog_name=postfix/submission

Run the following commands.

    $ sudo ufw limit 587/tcp
    $ sudo ufw limit 993/tcp

Run the following commands.

    $ sudo postfix reload
    $ sudo service dovecot restart

Configure your favorite mail client likewise.  
Inbound:

    - Protocol: IMAP
    - Server: your-domain.com
    - Port: 993
    - Username: your-user
    - Password: your-user's linux password
    - Encryption: TLS
    - Authentication: Clear text

Outbound:

    - Protocol: SMTP
    - Server: your-domain.com
    - Port: 587
    - Username: your-user
    - Password: your-user's linux password
    - Encryption: TLS
    - Authentication: Plain

Setting up a git repository
---------------------------
Run the following command on the server.

    $ sudo apt-get install git-core

Run the following commands on the server.

    $ mkdir ~/some-project
    $ cd ~/some-project
    $ git init --bare

Run the following command from your laptop.

    $ git clone your-name@your-domain.com:/home/your-name/some-project

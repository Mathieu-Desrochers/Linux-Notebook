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

Get the one mounted under media, where X is a letter and 0 is a number.  
Double check the device size just to make sure.

Run the following commands.

    $ umount /dev/sdX0
    $ sudo dd bs=4M if=2015-11-21-raspbian-jessie-lite.img of=/dev/sdX
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

Get the name of your connected network interface.  
Run the following command.

    $ sudo arp-scan --interface=wlan0 --localnet
    ...
    192.168.1.102   b8:27:eb:cb:c2:cf       (Unknown)
    ...

Get the IP address on the line showing b8:27.  
This is the pi's current address on your network.

Connecting to the pi
--------------------
Run the following commands.

    $ ssh pi@192.168.1.102
    password: raspberry

    $ adduser your-name
    $ adduser your-name sudo

    $ exit

Now reconnect as yourself and run the following commands.

    $ ssh your-name@192.168.1.102

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

Setting up a firewall
---------------------
Run the following command to install the firewall.

    $ sudo apt-get install ufw

Edit the following file and set IPV6=no.

    /etc/default/ufw

Run the following commands.

    $ sudo ufw default allow outgoing
    $ sudo ufw default deny incoming
    $ sudo ufw allow OpenSSH
    $ sudo ufw enable

Banning failed logins
---------------------
Run the following command.

    $ sudo apt-get install fail2ban
    $ sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

Edit the following file.

    /etc/fail2ban/jail.local

Replace its content with the following lines.

    [DEFAULT]
    bantime  = 600  ; 10 minutes
    findtime = 600  ; 10 minutes
    maxretry = 3

    [ssh]
    enabled  = true
    port     = ssh
    filter   = sshd
    logpath  = /var/log/auth.log
    maxretry = 6

    [recidive]
    enabled  = true
    filter   = recidive
    logpath  = /var/log/fail2ban.log
    action   = iptables-allports[name=recidive]
    bantime  = 604800  ; 1 week
    findtime = 86400   ; 1 day

Run the following command.

    $ sudo fail2ban-client reload

Banned addresses can be listed using one of the following commands.

    $ sudo fail2ban-client status ssh
    $ sudo fail2ban-client status recidive

Using dynamic DNS with NoIP
---------------------------
Open an account with noip.com for your existing domain name.  
This service has to be paid for.

Login to godaddy.com and select your existing domain name.  
Delegate the nameservers to the following addresses.

- ns1.no-ip.com
- ns2.no-ip.com
- ns3.no-ip.com
- ns4.no-ip.com
- ns5.no-ip.com

Run the following commands.

    cd /tmp
    wget http://www.no-ip.com/client/linux/noip-duc-linux.tar.gz
    tar xzf noip-duc-linux.tar.gz
    cd noip-2.1.9-1
    make
    sudo make install

Create the following file.

    /etc/init.d/noip

With the following content.

    #! /bin/sh

    ### BEGIN INIT INFO
    # Provides:          noip
    # Required-Start:    $remote_fs $syslog
    # Required-Stop:     $remote_fs $syslog
    # Default-Start:     2 3 4 5
    # Default-Stop:      0 1 6
    ### END INIT INFO

    case "$1" in
      start)
        echo "Starting noip"
        /usr/local/bin/noip2
        ;;
      stop)
        echo "Stopping noip"
        killall noip2
        ;;
      *)
        echo "Usage: /etc/init.d/noip {start|stop}"
        exit 1
        ;;
    esac

    exit 0

Run the following commands.

    $ sudo chmod 755 /etc/init.d/noip
    $ sudo update-rc.d noip defaults

    $ sudo /etc/init.d/noip start

Confirm there is a A record for your domain.  
This can be done with the following command.

    $ dig A your-domain.com +short @ns1.no-ip.com
    111.222.333.444

Allowing mail reception
-----------------------
We assume your ISP is blocking port 25 inbound and outbound.  
Login to noip.com and register for Mail Reflector. This service has to be paid for.

Configure the following settings.

- Mail Server: your-domain.com
- Port Number: 2525

Confirm there is a MX record for your domain.  
This can be done with the following command.

    $ dig MX your-domain.com +short @ns1.no-ip.com
    10 mail2.no-ip.com.
    5 mail1.no-ip.com.

Run the following commands.

    $ sudo apt-get install postfix
    $ sudo postfix stop

Edit the following file.

    /etc/postfix/master.cf

Apply the following change.

    ---- smtp      inet  n ...
    ++++ 2525      inet  n ...

Edit the following file.

    /etc/postfix/main.cf

Replace its content with the following lines.

    myhostname = mail.your-domain.com
    mydomain = your-domain.com
    myorigin = $mydomain
    mydestination = $myhostname localhost.$mydomain localhost $mydomain
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

    /etc/ufw/applications.d/postfix

Apply the following change.

    ---- ports=25/tcp
    ++++ ports=2525/tcp

Run the following commands.

    $ sudo ufw allow 'Postfix'
    $ sudo ufw allow 'Postfix SMTPS'
    $ sudo ufw allow 'Postfix Submission'

Edit the following file.

    /etc/fail2ban/jail.local

Append the following lines.

    [postfix]
    enabled  = true
    port     = 2525,ssmtp,submission
    filter   = postfix
    logpath  = /var/log/mail.log

Run the following command.

    $ sudo fail2ban-client reload
    $ sudo postfix start

Allowing mail delivery
----------------------
Run the following command.

    $ sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048
        -keyout /etc/ssl/private/mail.key
        -out /etc/ssl/certs/mailcert.pem

    $ sudo chmod 600 /etc/ssl/private/mail.key

Run the following command.

    $ apt-get install dovecot-imapd

Edit the following file.

    /etc/dovecot/dovecot.conf

Replace its content with the following lines.

    protocols = imap
    mail_location = maildir:~/Maildir

    ssl = required
    ssl_cert = </etc/ssl/certs/mailcert.pem
    ssl_key = </etc/ssl/private/mail.key

    auth_mechanisms = plain login

    userdb {
      driver = passwd
    }

    passdb {
      driver = pam
      args = %s
    }

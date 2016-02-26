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

Now reconnect as yourself and run the following commands.

    $ ssh your-name@192.168.1.102
    $ sudo deluser -remove-home pi

Basic setup
-----------
Run the following commands.

    $ sudo apt-get update
    $ sudo apt-get upgrade

    $ sudo hostnamectl set-hostname tombstone
    $ dpkg-reconfigure tzdata

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

    /etc/ssh/sshd_conf

Apply the following changes.

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

Using dynamic DNS with NoIP
---------------------------
Open an account with noip.com for your existing domain name.  
This service has to be paid for, a better alternative would be  
having a static IP address.

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

Setting up a mail server
------------------------
We assume your ISP is blocking port 25 inbound and outbound.  
Login to noip.com and register for the Mail Reflector service.  
This service has to be paid for, a better alternative would be  
having a static IP address with all ports opened.

Configure the following settings.

- Mail Server: your-domain.com
- Port Number: 2525

Confirm NoIP registered a MX record for your domain.  
This can be done with the following command.

    $ dig MX your-domain.com +short @ns1.no-ip.com
    10 mail2.no-ip.com.
    5 mail1.no-ip.com.

Run the following commands.

    $ sudo apt-get install postfix
    $ sudo postfix stop

Answer the following when prompted.

- Internet Site
- your-domain.com

Edit the following file.

    /etc/postfix/master.cf

Apply the following change.

    ---- smtp      inet  n ...
    ++++ 2525      inet  n ...

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

    $ sudo ufw allow 2525/tcp

Edit the following file.

    /etc/fail2ban/jail.local

Append the following lines.

    [postfix]
    enabled  = true
    port     = 2525
    filter   = postfix
    logpath  = /var/log/mail.log

Run the following command.

    $ sudo fail2ban-client reload
    $ sudo newaliases
    $ sudo postfix start

Using the mail server remotely
------------------------------
Run the following command on both  
the server and your laptop.

    $ sudo apt-get install maildirsync

Run the following command on your laptop to download your mail.  
Make sure to be in your home directory.

    $ maildirsync -r --maildirsync=maildirsync
        your-name@your-domain.com:Maildir Maildir
        .maildirsync.laptop.gz

Configure your favorite mail client.

    Identity: Your Name (mail@your-domain.com)
    Receive from: Local mail folder (~/Maildir)
    Send to: some-relay@your-isp.com

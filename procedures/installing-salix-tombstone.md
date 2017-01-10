Configuring the BIOS
--------------------
Apply the following settings.

- Date and time: Now as UTC
- Secure Boot: Disabled

Reboot with the USB DVD connected.

Salix installation
------------------
Select the following options.

- Keep the current keymap
- Exit the installation

Creating the disk partitions
----------------------------
Run the following commands.

    $ gdisk /dev/mmcblk0

    Command (? for help): o
    Command (? for help): n 1 default +128M ef00
    Command (? for help): n 2 default +24G default
    Command (? for help): n 3 default +1G 8200
    Command (? for help): w

    $ mkfs.msdos -F 32 /dev/mmcblk0p1
    $ cryptsetup -s 256 -y luksFormat /dev/mmcblk0p2
    $ cryptsetup luksOpen /dev/mmcblk0p2 luksmmcblk0p2
    $ setup

Salix installation
------------------
Pay attention to the following options.

- Partitions editor: Exit
- Select Linux installation partition: /dev/mapper/luksmmcblk0p2
- Select installation mode: Core
- Install LILO: skip
- Network: tombstone tombstone DHCP
- Exit to command line

Configuring the file systems
----------------------------
Edit the following file.

    /mnt/etc/crypttab

Add the following lines.

    luksmmcblk0p2    /dev/mmcblk0p2
    luksmmcblk0p3    /dev/mmcblk0p3    none    swap

Edit the following file.

    /mnt/etc/fstab

Adjust the following line.

    /dev/mapper/luksmmcblk0p3   swap   swap   defaults   0   0

Configuring the boot loader
---------------------------
Run the following commands.

    $ mount -o bind /proc /mnt/proc
    $ mount -o bind /sys /mnt/sys
    $ chroot /mnt

Run the following command to get the modules loaded by the installer.  
Join them with : for the -m option of the next command.

    $ lsmod

Run the following command.

    $ mkinitrd -c -k 4.4.19 -f ext4 -m mmc_core:mmc_block:...
        -r /dev/mapper/luksmmcblk0p2 -C /dev/mmcblk0p2 -L

Edit the following file.

    /usr/sbin/eliloconfig

Hack the following variable assignations.

    EFI_DEVICE="/dev/mmcblk0"
    EFI_PARTITION=1

Run the following command.

    $ mkdir /boot/efi
    $ mount /dev/mmcblk0p1 /boot/efi
    $ eliloconfig

Edit the following file.

    /boot/efi/EFI/Salix-Core-14.2/elilo.conf

Delete the last line.

    append="root=..."

Reboot and pray.

Enabling SSH
------------
Edit the following file.

    /etc/ssh/sshd_config

Set the following options.

    PermitRootLogin no
    PubkeyAuthentication yes
    AuthorizedKeysFile .ssh/authorized_keys
    PasswordAuthentication no
    AllowUsers your-account

Copy your public RSA key to this file.

    /home/your-account/.ssh/authorized_keys

Run the following commands.

    $ chmod +x /etc/rc.d/rc.sshd
    $ /etc/rc.d/rc.sshd start

Configuring the firewall
------------------------
Create the following file.

    /etc/rc.d/rc.firewall

With the following content.

    #!/bin/bash
    if [ "$1" = "start" ]
    then
      echo "Applying firewall configuration"

      iptables -F
      iptables -X
      iptables -Z

      iptables -P INPUT DROP
      iptables -P FORWARD DROP
      iptables -P OUTPUT ACCEPT

      iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

      iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --set
      iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --update --seconds 300 --hitcount 10 -j DROP
      iptables -A INPUT -p tcp --dport 22 -j ACCEPT

      iptables -A INPUT -p tcp --dport 25 -m state --state NEW -m recent --set
      iptables -A INPUT -p tcp --dport 25 -m state --state NEW -m recent --update --seconds 300 --hitcount 10 -j DROP
      iptables -A INPUT -p tcp --dport 25 -j ACCEPT

      iptables -A INPUT -p tcp --dport 587 -m state --state NEW -m recent --set
      iptables -A INPUT -p tcp --dport 587 -m state --state NEW -m recent --update --seconds 300 --hitcount 10 -j DROP
      iptables -A INPUT -p tcp --dport 587 -j ACCEPT

      iptables -A INPUT -p tcp --dport 993 -m state --state NEW -m recent --set
      iptables -A INPUT -p tcp --dport 993 -m state --state NEW -m recent --update --seconds 300 --hitcount 10 -j DROP
      iptables -A INPUT -p tcp --dport 993 -j ACCEPT

      ip6tables -F
      ip6tables -X
      ip6tables -Z

      ip6tables -P INPUT DROP
      ip6tables -P FORWARD DROP
      ip6tables -P OUTPUT DROP
    fi

Run the following command.

    $ chmod +x /etc/rc.d/rc.firewall

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

    $ groupadd -g 200 postfix
    $ groupadd -g 201 postdrop
    $ useradd -u 200 -d /dev/null -s /bin/false -g postfix postfix
    $ sudo spi -i postfix

Edit the following file.

    /etc/postfix/main.cf

Adjust the following settings.

    myhostname = your-domain.com
    mydomain = your-domain.com
    myorigin = $mydomain
    mydestination = $mydomain
    mynetworks_style = host
    relay_domains =

    smtpd_relay_restrictions = permit_sasl_authenticated, reject_unauth_destination
    smtpd_recipient_restrictions = permit_sasl_authenticated, reject_unauth_destination

    smtpd_sasl_auth_enable = yes
    smtpd_sasl_type = dovecot
    smtpd_sasl_path = private/auth

    smtp_tls_security_level = may
    smtpd_tls_security_level = may
    smtpd_tls_cert_file = /etc/ssl/certs/mailcert.pem
    smtpd_tls_key_file = /etc/ssl/private/mail.key

    home_mailbox = Maildir/

Run the following commands.

    $ userdel mail
    $ useradd -m -U mail
    $ passwd mail

Create the following file.

    /etc/aliases

With the following content.

    postmaster: mail
    root: mail

Run the following command.

    $ newaliases

Serving mail remotely
---------------------
Run the following command.

    $ groupadd -g 202 dovecot
    $ useradd -d /dev/null -s /bin/false -u 202 -g 202 dovecot
    $ groupadd -g 248 dovenull
    $ useradd -d /dev/null -s /bin/false -u 248 -g 248 dovenull
    $ spi -i dovecot

Create the following file.

    /etc/dovecot/dovecot.conf

With the following content.

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

    /etc/postfix/master.cf

Uncomment the following lines.

    submission inet n       -       -       -       -       smtpd
      -o syslog_name=postfix/submission

Run the following commands.

    $ chmod +x /etc/rc.d/rc.postfix
    $ chmod +x /etc/rc.d/rc.dovecot

    $ /etc/rc.d/rc.postfix start
    $ /etc/rc.d/rc.dovecot start

Configuring a mail client
-------------------------

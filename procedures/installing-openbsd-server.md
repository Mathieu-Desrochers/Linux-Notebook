Full Disk Encryption
--------------------
Select the following option.

    (S)hell

Run the following commands.

    # cd /dev && sh MAKEDEV sd0
    # dd if=/dev/urandom of=/dev/rsd0c bs=1m
    # fdisk -iy sd0
    # disklabel -E sd0

    sd0> a a
    offset: [64]
    size: []
    FS type: [4.2BSD] RAID
    sd0*> w
    sd0> q

    # bioctl -c C -l sd0a softraid0
    # cd /dev && sh MAKEDEV sd1
    # dd if=/dev/zero of=/dev/rsd1c bs=1m count=1
    # exit

OpenBSD Installation
--------------------
Select the following options.

    (I)nstall

    system hostname: deep-thought
    network interface: vio0
    ipv4 address: dhcp
    ipv6 address: none

    start sshd: yes
    run x window system: no
    setup user: your-account
    password: hunter2
    root ssh login: no

    root disk: sd1
    whole disk mrb
    auto layout or edit auto layout

    sd0> R h
    new size (with unit) 8G
    sd0*> w
    sd0> q

Run the following command.

    # syspatch

Create the file /etc/doas.conf

    permit persist :wheel

Securing SSH
------------
Upload your public ssh key using scp  
and the password for your-user.

    scp key your-user@192.168.100.100:.ssh/authorized_keys

Update the file /etc/ssh/sshd\_config.

    AuthenticationMethods publickey

Update the file /etc/pf.conf.

    set skip on lo
    antispoof for vio0 inet

    block all
    block in quick from urpf-failed

    pass in log on vio0 proto tcp to server-ip port 22
    pass out on vio0 proto { tcp udp icmp } from server-ip

Reboot feeling a little safer.

Cherry Picking Services
-----------------------
Create the file /etc/rc.conf.local

    ntpd_flags=NO
    slaacd_flags=NO
    smtpd_flags=NO
    sndiod_flags=NO

Bells and Whistles
------------------
Update the file ~/.profile.

    PS1="\[\033[31m\]\u@\h:\w\\$\[\033[0m\] "
    export PS1

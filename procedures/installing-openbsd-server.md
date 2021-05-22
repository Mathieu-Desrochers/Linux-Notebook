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
    size: [] *
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
    auto layout

Time spent reading the following is well invested.

    # man afterboot

Run the following command.

    # syspatch

Create the file /etc/doas.conf

    permit persist :wheel

Securing SSH
------------
Upload your public ssh key using scp  
and the password for your-user.

    scp key your-user@deep-thought-ip:.ssh/authorized_keys

Update the file /etc/ssh/sshd\_config

    AuthenticationMethods publickey

Update the file /etc/pf.conf

    set skip on lo
    antispoof for vio0 inet

    block all
    block in quick from urpf-failed

    pass in log on egress proto tcp to vio0 port ssh
    pass out on egress proto { tcp udp icmp } from vio0

Reboot feeling a little safer.

Cherry Picking Services
-----------------------
Create the file /etc/rc.conf.local

    ntpd_flags=NO
    slaacd_flags=NO
    sndiod_flags=NO

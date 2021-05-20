OpenBSD Installation
--------------------
Select the following option.

  - (S)hell

Full Disk Encryption
--------------------
Mount the first drive.

    # cd /dev && sh MAKEDEV sd0

Initialize its content with random data.  
The r denotes a raw device (characters instead of blocks).  
The c partition denotes the whole drive.

    # dd if=/dev/urandom of=/dev/rsd0c bs=1m

Create the master boot record.

    # fdisk -iy sd0

Create a partition spanning the whole drive.

    # disklabel sd0

    sd0> a a
    offset: [64]
    size: [999999999]
    FS type: [4.2BSD] RAID
    sd0*> w
    sd0> q

Create an encrypted device on the partition.

    # bioctl -c C -l sd0a softraid0

Mount the device and zero it's first megabyte.  
Then resume the installation.

    # cd /dev && sh MAKEDEV sd1
    # dd if=/dev/zero of=/dev/rsd1c bs=1m count=1
    # exit

OpenBSD Installation
--------------------
Select the following options.

  - (I)nstall

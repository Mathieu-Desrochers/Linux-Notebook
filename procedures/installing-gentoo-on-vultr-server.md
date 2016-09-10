Building the kernel
-------------------
Add the following options.

    Processor type and features
      [*] Linux guest support

    Device drivers
      Block devices
        <*> Virtio block driver
      SCSI device suppoer
        SCSI low-lever drivers
          <*> virtio-scsi support
      Network device support
        Network driver support
          <*> Virtio network driver
      Virtuo drivers
        <*> PCI drivers for virtio devices
          [*] Support for legacy virtio draft 0.9.X and older devices
        <*> Virtio balloon driver
        <*> Platform bus driver for memory mapped virtio devices

    Virtualization
      [*] Host kernel accelerator for virtuo net

Building the initramfs
----------------------
Add the following switch to this command.

    $ genkernel --virtio initramfs

Configuring SSH
---------------
Edit the following file.

    /etc/ssh/sshd_config

Set the following options.

    PermitRootLogin no
    AuthorizedKeysFile .ssh/authorized_keys
    PasswordAuthentication no
    UsePAM no
    AllowUsers my-account

Run the following command.

    $ sudo /etc/init.d/ssh restart

Kernel options for a server
---------------------------
Select the following options.

    Processor type and features
      [*] Linux guest support
          Processor family
            (X) Core 2/Newer Xeon

    Device drivers
      Block devices
        <*> Virtio block driver
      Multiple devices driver support (RAID and LVM)
        Device mapper support
          <*> Crypt target support
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

    Cryptographic API
      <*> XTS support
      <*> AES cipher algorithms (x86_64)

    Virtualization
      [*] Host kernel accelerator for virtuo net

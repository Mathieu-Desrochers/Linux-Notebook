Kernel options for a laptop
---------------------------
Select the following options.

    Processor type and features
      Processor family
        (X) Core 2/Newer Xeon

    Device drivers
      Multiple devices driver support (RAID and LVM)
        Device mapper support
          <*> Crypt target support
      Network device support
        Network core driver support
          <*> Universal TUN/TAP device driver support
        Ethernet driver support
          [*] Realtek devices
            <M> Realtek 8169 gigabit ethernet support
        Wireless LAN
          <M> Atheros Wireless Cards
            <M> Atheros 802.11n wireless cards support
              [*] Atheros ath9k PCI/PCIe bus support

    Cryptographic API
      <*> XTS support
      <*> AES cipher algorithms (x86_64)

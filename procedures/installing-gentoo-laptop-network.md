Setting up the network on a laptop
----------------------------------
Run the following commands.

    $ ln -s /etc/init.d/net.lo /etc/init.d/net.enp2s0
    $ ln -s /etc/init.d/net.lo /etc/init.d/net.wlp1s0

Edit the following file.

    /etc/conf.d/hostname

Modify the following variable.

    hostname="laptop"

Edit the following file.

    /etc/issue

Set the following content.

    This is \n (\s \m \r) \t

Run the following commands.

    $ emerge --ask net-misc/dhcpcd
    $ emerge --ask net-wireless/wpa_supplicant

Edit the following file.

    /etc/wpa_supplicant/wpa_supplicant.conf

Set the following content.

    ctrl_interface=/var/run/wpa_supplicant
    eapol_version=1
    ap_scan=1

    network={
      ssid=""
      psk=""
    }

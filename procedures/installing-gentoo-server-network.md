Setting up the network on a server
----------------------------------
Run the following commands.

    $ ln -s /etc/init.d/net.lo /etc/init.d/net.eth0
    $ rc-update add net.eth0 default

Edit the following file.

    /etc/conf.d/hostname

Modify the following variable.

    hostname="server-name"

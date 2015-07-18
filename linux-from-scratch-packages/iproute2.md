iproute2
--------
Shows / manipulates routing, devices, policy routing and tunnels.

Listing the links
-----------------
Run the following command:

    $ ip link list
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    2: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
    link/ether 00:1c:42:e6:59:5a brd ff:ff:ff:ff:ff:ff

This shows the following network interfaces:

- The loopback link (with no MAC address)
- The ethernet link (with MAC address 00:1c:42:e6:59:5a)

Listing the addresses
---------------------
Run the following command:

    $ ip address show
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
        ...
    2: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
        link/ether 00:1c:42:e6:59:5a brd ff:ff:ff:ff:ff:ff
        inet 10.211.55.6/24 brd 10.211.55.255 scope global eth1
        ...

This shows us the following IP address bindings:

- 127.0.0.1 is bound to the loopback link
- 10.211.55.6 is bound to the ethernet link

Furthermore we get shown that for the 10.211.55.6 address:

- The first 24 bits identify the network (10.211.55.*)
- The remaining 8 bits are specifically assigned to us (0.0.0.6)

Listing the routes
------------------
Run the following command:

    $ ip route show
    10.211.55.0/24 dev eth1  proto kernel  scope link  src 10.211.55.6  metric 1
    default via 10.211.55.1 dev eth1  proto static

This shows us that:

- Packets addressed to 10.211.55.* should be sent directly on the ethernet link
- Any other packet shoud be sent via the 10.211.55.1 gateway on the ethernet link

Listing the address resolutions
-------------------------------
Run the following commands:

    $ ping 10.211.55.1

    $ ip neigh show
    10.211.55.1 dev eth1 lladdr 00:1c:42:00:00:18 REACHABLE
    ...

This shows us that:

- The IP address 10.211.55.1 was resolved to MAC address 00:1c:42:00:00:18

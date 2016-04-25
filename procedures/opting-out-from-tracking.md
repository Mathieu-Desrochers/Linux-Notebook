Do not give them your IP address
--------------------------------
Open an account with NordVPN.  
This service has to be paid for.

    https://nordvpn.com/

Download the .ovpn file of your choice from their website.  
Place it in the following folder.

    /etc/openvpn

Apply the following change to the .ovpn file.

    ---- auth-user-pass
    ++++ auth-user-pass /home/your-name/.vpn

Create the following file.

    /home/your-name/.vpn

With the following content.

    nordvpn-username
    nordvpn-password

Create the start-vpn-client.sh file with the following content.

    #! /bin/bash
    /usr/sbin/openvpn --config /etc/openvpn/your.ovpn
      --writepid /var/run/openvpn.pid

Simply refuse to talk to them
-----------------------------
Download the hosts file from the following website.

    https://github.com/StevenBlack/hosts

Put its content in the following file.

    /etc/hosts

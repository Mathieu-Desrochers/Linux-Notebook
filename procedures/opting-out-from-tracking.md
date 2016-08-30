Do not give them your IP address
--------------------------------
Open an account with NordVPN.  
This service has to be paid for.

    https://nordvpn.com/

Download the .ovpn file of your choice from their website.  
Copy it in the following location.

    /etc/openvpn/openvpn.conf

Apply the following change to the file.

    ---- auth-user-pass
    ++++ auth-user-pass /home/your-name/.vpn

Create the following file.

    /home/your-name/.vpn

With the following content.

    nordvpn-username
    nordvpn-password

Simply refuse to talk to them
-----------------------------
Download the hosts file from the following website.

    https://github.com/StevenBlack/hosts

Put its content in the following file.

    /etc/hosts

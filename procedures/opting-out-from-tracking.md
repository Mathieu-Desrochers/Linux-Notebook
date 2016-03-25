Do not give them your IP address
--------------------------------
Open an account with NordVPN.  
This service has to be paid for.

    https://nordvpn.com/

Download the following files from their website.

- *.ovpn
- *.crt
- *.key

Place them in the following folder.

    ~/.vpn

From the Network Connections interface,  
perform the following actions.

- Add
- Choose a Connection Type: Import a saved VPN configuration...
- Select a file to import: ~/.vpn/ca12.nordvpn.com.tcp443.ovpn
- Connection name: NordVPN 12
- User name: your-username
- Password: your-password
- CA Certificate: ~/.vpn/ca12_nordvpn_com_ca.crt
- Advanced...
- TLS Authentication
- Use additional TLS authentication: Checked
- Key File: ~/.vpn/ca12_nordvpn_com_tls.key
- Key Direction: 1

Your might want to repeat these steps  
to register other available VPN servers.

Simply refuse to talk to them
-----------------------------
Download the hosts file from the following website.

    https://github.com/StevenBlack/hosts

Put its content in the following file.

    /etc/hosts

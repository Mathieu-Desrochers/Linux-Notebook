Masking your IP address
-----------------------
Open an account with NordVPN.  
This service has to be paid for.

    https://nordvpn.com/

Run the following commands.

    cd /etc/openvpn
    sudo wget https://nordvpn.com/api/files/zip
    sudo unzip zip
    sudo rename 's/ovpn/conf/' *.ovpn
    sudo rm zip

Edit the following file.

    /etc/default/openvpn

Apply the following change.

    ---- #AUTOSTART="all"
    ++++ AUTOSTART="ca17.nordvpn.com.tcp443"

Edit the following file.

    /etc/openvpn/ca17.nordvpn.com.tcp443.conf

Apply the following change.

    ---- auth-user-pass
    ++++ auth-user-pass /home/mathieu/.vpn

Create the following file.

    /home/your-name/.vpn

With the following content.

    nordvpn-username
    nordvpn-password

Run the following commands.

    chmod 600 /home/your-name/.vpn
    sudo shutdown --reboot now

Setting up a firewall on a server
---------------------------------
Run the following commands.

    $ emerge --ask net-firewall/iptables
    $ rc-service iptables save

Run the following commands.  
This will only let in ssh and https.

    iptables -F
    iptables -X
    iptables -Z

    iptables -P INPUT DROP
    iptables -P FORWARD DROP
    iptables -P OUTPUT ACCEPT

    iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

    iptables -A INPUT -p tcp --dport 22 -j ACCEPT
    iptables -A INPUT -p tcp --dport 443 -j ACCEPT

    ip6tables -F
    ip6tables -X
    ip6tables -Z

    ip6tables -P INPUT DROP
    ip6tables -P FORWARD DROP
    ip6tables -P OUTPUT DROP

Setting up a firewall on a laptop
---------------------------------
Run the following commands.

    $ emerge --ask net-firewall/iptables
    $ rc-service iptables save
    $ rc-update add iptables default

Run the following commands.  
Where 162.219.176.19 is the address of your VPN.  
All traffic will be forced through there.

    iptables -F
    iptables -X
    iptables -Z

    iptables -P INPUT DROP
    iptables -P FORWARD DROP
    iptables -P OUTPUT DROP

    iptables -A INPUT -s 162.219.176.19 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    iptables -A INPUT -p udp --sport 53 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    iptables -A INPUT -i tun0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    iptables -A INPUT -i lo -j ACCEPT

    iptables -A OUTPUT -d 162.219.176.19 -j ACCEPT
    iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
    iptables -A OUTPUT -o tun0 -j ACCEPT
    iptables -A OUTPUT -o lo -j ACCEPT

    ip6tables -F
    ip6tables -X
    ip6tables -Z

    ip6tables -P INPUT DROP
    ip6tables -P FORWARD DROP
    ip6tables -P OUTPUT DROP

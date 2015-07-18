inetutils
---------
Network utilities.

hostname
--------
Run the following command:

    $ hostname
    apollo

ping
----
Run the following command:

    $ ping www.google.com
    PING www.google.com (74.125.226.116) 56(84) bytes of data.
    64 bytes from yyz08s13-in-f20.1e100.net (74.125.226.116): icmp_seq=1 ttl=128 time=7.85 ms

traceroute
----------
Run the following command:

    $ traceroute www.google.com
    traceroute to www.google.com (74.125.136.104), 30 hops max, 60 byte packets
     1  router2-nac.linode.com (207.99.1.14)  0.421 ms  0.543 ms  0.718 ms
     2  207.99.53.45 (207.99.53.45)  0.978 ms  1.036 ms  1.108 ms
     3  0.e1-2.tbr2.ewr.nac.net (209.123.10.113)  0.927 ms  0.905 ms  1.015 ms
     4  core1-0-0-8.lga.net.google.com (198.32.118.39)  1.348 ms  1.365 ms  1.350 ms
    ...
    12  ea-in-f104.1e100.net (74.125.136.104)  87.037 ms  86.909 ms  86.949 ms

whois
-----
Run the following command:

    $ whois google.com
    Domain Name: google.com
    ...
    Registrant Organization: Google Inc.
    Registrant Street: Please contact contact-admin@google.com, 1600 Amphitheatre Parkway
    Registrant City: Mountain View
    Registrant State/Province: CA
    Registrant Postal Code: 94043
    Registrant Country: US
    ...

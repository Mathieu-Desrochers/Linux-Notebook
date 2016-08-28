awk
---
Pattern scanning and processing language.

Creating the test file
----------------------
Run the following command:

    $ cat > order.txt << "EOF"
    Order number: 001
    Customer: ACME

    1    Piano     15000
    5    Dogs        895
    12   Bananas       6

    Notes: Free shipping
    EOF

Scanning lines
--------------
Run the following commands:

    $ cat > script.awk << "EOF"
    # only lines starting with a number
    # print the second field
    /^[0-9]+/    { print $2; }
    EOF

    $ awk -f script.awk < order.txt
    Piano
    Dogs
    Bananas

    $ cat > script.awk << "EOF"
    # only expensive items
    # tidle means matching regex
    $1 ~ /[0-9]+/ && $3 > 100     { print $2; }
    EOF

    $ awk -f script.awk < order.txt
    Piano
    Dogs

Processing lines
----------------
Run the following commands:

    $ cat > script.awk << "EOF"
    BEGIN        { total = 0; }
    /^[0-9]+/    { total += $3 }
    END          { print "Total: ", total; }
    EOF

    $ awk -f script.awk < order.txt
    Total:  15901

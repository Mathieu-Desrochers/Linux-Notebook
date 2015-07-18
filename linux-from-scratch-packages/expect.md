expect
------
A program to automate interactions with programs that expose a text terminal interface.

Creating the script
-------------------
Run the following command:

    $ cat > script.exp << "EOF"
    spawn ftp ftp.mozilla.org
    expect "Name"
    send "anonymous\n"
    expect "Password"
    send "\n"
    expect "ftp>"
    send "close\n"
    expect "ftp>"
    send "bye\n"
    expect eof
    EOF

Running the script
------------------
Run the following command:

    $ expect script.exp

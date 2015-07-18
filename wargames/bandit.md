bandit
======

- http://overthewire.org/wargames/bandit/
- ssh bandit.labs.overthewire.org

bandit0
-------
The password for the next level is stored in a file called readme located in the home directory.

    cat readme

bandit1
-------
The password for the next level is stored in a file called - located in the home directory.

    cat ./-

bandit2
-------
The password for the next level is stored in a file called spaces in this filename located in the home directory.

    cat 'spaces in this filename'

bandit3
-------
The password for the next level is stored in a hidden file in the inhere directory.

    ls -a inhere
    cat inhere/.hidden

bandit4
-------
The password for the next level is stored in the only human-readable file in the inhere directory.

    file inhere/*
    cat inhere/-file07

bandit5
-------
The password for the next level is stored in a file somewhere under the inhere directory and has all of the following properties:

- human-readable
- 1033 bytes in size
- not executable

Commands:

    find . -size 1033c ! -executable
    cat ./inhere/maybehere07/.file2

bandit6
-------
The password for the next level is stored somewhere on the server and has all of the following properties:

- owned by user bandit7
- owned by group bandit6
- 33 bytes in size

Commands:

    id -u bandit7
    id -g bandit6
    find / -uid 11007 -gid 11006 -size 33c 2>/dev/null
    cat /var/lib/dpkg/info/bandit7.password

bandit7
-------
The password for the next level is stored in the file data.txt next to the word millionth.

    grep millionth data.txt

bandit8
-------
The password for the next level is stored in the file data.txt and is the only line of text that occurs only once.

    sort data.txt | uniq -u

bandit9
-------
The password for the next level is stored in the file data.txt in one of the few human-readable strings, beginning with several ‘=’ characters.

    strings data.txt | grep ===

bandit10
--------
The password for the next level is stored in the file data.txt, which contains base64 encoded data.

    base64 -d data.txt

bandit11
--------
The password for the next level is stored in the file data.txt, where all lowercase (a-z) and uppercase (A-Z) letters have been rotated by 13 positions.

    tr 'A-Za-z' 'N-ZA-Mn-za-m' < data.txt

bandit12
--------
The password for the next level is stored in the file data.txt, which is a hexdump of a file that has been repeatedly compressed.

    cd $(mktemp -d)
    cp ~/data.txt .
    xxd -r data.txt data1.bin
    file data1.bin
    gunzip < data1.bin > data2.bin
    file data2.bin
    bunzip2 < data2.bin > data3.bin
    file data3.bin
    gunzip < data3.bin > data4.bin
    file data3.bin
    tar -xf data4.bin
    file data5.bin
    tar -xf data5.bin
    file data6.bin
    bunzip2 < data6.bin > data7.bin
    file data7.bin
    tar -xf data7.bin
    file data8.bin
    gunzip < data8.bin > data9.bin
    cat data9.bin

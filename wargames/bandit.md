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

findutils
---------
The basic directory searching utilities of the GNU operating system.

find
----
Searches for files in a directory hierarchy.  
Run the following commands:

    $ mkdir directory/
    $ touch directory/a.txt
    $ touch directory/b.txt

    $ mkdir directory/sub-directory/
    $ touch directory/sub-directory/a.txt
    $ touch directory/sub-directory/b.txt

    $ find -name a.txt
    ./directory/a.txt
    ./directory/sub-directory/a.txt

xargs
-----
Builds and execute command lines from standard input.  
Run the following commands:

    $ find -name a.txt | xargs -t touch
    touch ./directory/a.txt ./directory/sub-directory/a.txt

    $ find -name a.txt | xargs -t -i cp {} {}.bak
    cp ./directory/a.txt ./directory/a.txt.bak
    cp ./directory/sub-directory/a.txt ./directory/sub-directory/a.txt.bak

updatedb
--------
Updates a file name database.  
Run the following commands:

    $ sudo updatedb

locate
------
Lists files in databases that match a pattern.  
Run the following commands:

    $ locate vim
    /etc/vim
    /etc/alternatives/rvim
    /etc/alternatives/vimdiff
    /etc/vim/vimrc
    ...

    $ locate -r ".*/vim$"
    /etc/vim

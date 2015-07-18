gzip
----
Compress or expand files.

Creating a test file
--------------------
Run the following commands:

    $ echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod " > test
    $ echo "tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, " >> test
    $ echo "quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. " >> test
    $ echo "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu " >> test
    $ echo "fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, " >> test
    $ echo "sunt in culpa qui officia deserunt mollit anim id est laborum." >> test

    $ ll -h test*
    -rw-rw-r-- 1 root root 451 Apr 15 18:03 test

Compressing a file
------------------
Run the following commands:

    $ gzip test

    $ ll test*
    -rw-rw-r-- 1 root root 294 Apr 15 18:03 test.gz

Listing an archive
------------------
Run the following commands:

    $ gzip -l test.gz
             compressed        uncompressed  ratio uncompressed_name
                    294                 451  39.9% test

Viewing the content of an archive
---------------------------------
Run the following commands:

    $ zcat test.gz
    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod
    ...

Decompressing a file
--------------------
Run the following commands:

    $ gunzip test.gz

    $ ll test*
    -rw-rw-r-- 1 root root 451 Apr 15 18:03 test

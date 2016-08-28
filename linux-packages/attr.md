attr
----
Extended attributes implement the ability for a user to attach name:value pairs to objects within the XFS filesystem.

Creating a test file
--------------------
Run the following command:

    $ touch file

Setting a file attribute
------------------------
Run the following command:

    $ attr -s color -V blue file
    Attribute "color" set to a 4 byte value for file:
    blue

Listing a file attributes
-------------------------
Run the following command:

    $ attr -l file  
    Attribute "color" has a 4 byte value for file

Getting a file attribute
------------------------
Run the following command:

    $ attr -g color file  
    Attribute "color" had a 4 byte value for file:
    blue

Removing a file attribute
-------------------------
Run the following command:

    $ attr -r color file

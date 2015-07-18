acl
---
Access Control Lists are used to define more fine-grained discretionary access rights for files and directories.

Enabling
--------
Edit the following file as sudo:

    /etc/fstab

Add the following mount option to the device:

    acl

Remount the device by running the following command:

    $ sudo mount / -o remount

Creating a test file
--------------------
Run the following command:

    $ touch /tmp/file

Creating test groups and users
------------------------------
Run the following commands:

    $ sudo groupadd sales

    $ sudo useradd alice
    $ sudo useradd bob

    $ sudo usermod -a -G sales alice
    $ sudo usermod -a -G sales bob

Modifying permissions
---------------------
Run the following commands:

    $ setfacl -m group:sales:rw- /tmp/file
    $ setfacl -m user:bob:r-- /tmp/file

Listing permissions
-------------------
Run the following commands:

    $ ll /tmp/file
    -rw-rw-r--+ 1 root root 0 Jan 1 11:11 /tmp/file

    $ getfacl /tmp/file
    user::rw-
    user:bob:r--
    group::rw-
    group:sales:rw-
    other::r--

Demonstrating permissions
-------------------------
Run the following commands:

    $ su - alice -c "touch /tmp/file"
    succeeds

    $ su - bob -c "touch /tmp/file"
    touch: cannot touch ‘/tmp/file’: Permission denied

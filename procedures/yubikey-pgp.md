Configure gnome-keyring to make way
-----------------------------------
Run the following commands:

    $ sudo cat > /usr/local/bin/gnome-keyring-daemon << "EOF"
    #!/bin/sh
    /usr/bin/gnome-keyring-daemon --start -c pkcs11,secrets
    EOF

    $ sudo chmod 777 /usr/local/bin/gnome-keyring-daemon

Installing the yubikey tools
----------------------------
Run the following commands:

    $ sudo apt-get install yubikey-personalization-gui yubikey-neo-manager yubikey-personalization
    $ sudo apt-get install pcscd scdaemon gnupg2 pcsc-tools

Enabling CCID on the yubikey
----------------------------
Run the following command:

    $ ykpersonalize -m82

Generating the encryption keys
------------------------------
Run the following command:

    $ gpg --card-edit
    admin
    generate
    Make off-card backup of encryption key? (Y/n) n
    quit

Exporting the public key
------------------------
Run the following command:

    $ gpg --armor --export your_email@address.com

Share it with the world.

Generating a revocation key
---------------------------
Run the following command:

    $ gpg --gen-revoke your_email@address.com

Do NOT share it with the world.  
Do NOT save it to file.

Common operations
-----------------
Sending a message to yourself:

    $ gpg --encrypt --armor -r your_email@address.com
    Hello
    CTRL+D

Reading a message sent to yourself:

    $ gpg
    -----BEGIN PGP MESSAGE-----
    Version: GnuPG v1
    ...
    -----END PGP MESSAGE-----
    CTRL+D
    Hello

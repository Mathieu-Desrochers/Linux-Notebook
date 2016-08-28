gettext
-------
Translates a natural language message into the user's language.

Creating the localizable program
--------------------------------
Run the following commands:

    $ cat > localizable.c << "EOF"
    #include <libintl.h>
    #include <locale.h>
    #include <stdio.h>

    int main()
    {
        setlocale(LC_MESSAGES, "");

        bindtextdomain("localizable", "/usr/local/share/locale");
        textdomain("localizable");

        printf(gettext("Hello world\n"));

        return 0;
    }
    EOF

Compiling the localizable program
---------------------------------
Run the following commands:

    $ gcc localizable.c -o localizable

Extracting the localizable strings
----------------------------------
Run the following commands:

    $ mkdir po
    $ xgettext -d localizable -o po/localizable.pot localizable.c

Localizing the strings
----------------------
Run the following commands:

    $ mkdir -p po/fr_FR
    $ cp po/localizable.pot po/fr_FR/localizable.po
    $ vim po/fr_FR/localizable.po

The CHARSET placeholder shoud be replaced.  
The default for french is ISO-8859-1.

Translations for each msgid line should be found on the next msgstr line.

Compiling the localized strings
-------------------------------
Run the following command:

    $ msgfmt po/fr_FR/localizable.po -o po/fr_FR/localizable.mo

Deploying the localized strings
-------------------------------
Run the following command:

    $ sudo mkdir -p /usr/local/share/locale/fr_FR/LC_MESSAGES
    $ sudo cp po/fr_FR/localizable.mo /usr/local/share/locale/fr_FR/LC_MESSAGES/

Demonstrating the localization
------------------------------
Run the following commands:

    $ ./localizable
    Hello world

    $ LANGUAGE=fr_FR
    $ ./localizable
    Bonjour monde

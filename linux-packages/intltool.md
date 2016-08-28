intltool
--------
Tools to centralize translation of many different file formats using GNU gettext-compatible PO files.

Creating the XML file with translatable elements
------------------------------------------------
Run the following commands:

    $ cat > test.xml << EOF
    <error>
      <code>1000</code>
      <_title>Big trouble</_title>
      <_description>Ran out of chocolate bars.</_description>
    </error>
    EOF

Marking the XML file as translatable
------------------------------------
Run the following commands:

    $ mkdir po

    $ cat > po/POTFILES.in << EOF
    test.xml
    EOF

Extracting the localizable strings
----------------------------------
Run the following commands:

    $ cd po
    $ intltool-update --pot -g template
    $ cd ..

Localizing the strings
----------------------
Run the following commands:

    $ mkdir -p po/fr_FR
    $ cp po/template.pot po/fr_FR/fr_FR.po
    $ vim po/fr_FR/fr_FR.po

The CHARSET placeholder shoud be replaced.  
UTF-8 is always a good choice.

Translations for each msgid line should be found on the next msgstr line.

Merging back the localized strings
----------------------------------
Run the following commands:

    $ intltool-merge -x po/fr_FR test.xml test.xml.fr

    $ cat test.xml.fr
    <?xml version="1.0" encoding="UTF-8"?>
    <error>
      <code>1000</code>
      <title>Big trouble</title>
      <title xml:lang="fr_FR">Gros problèmes</title>
      <description>Ran out of chocolate bars.</description>
      <description xml:lang="fr_FR">Nous sommes en rupture de chocolats.</description>
    </error>

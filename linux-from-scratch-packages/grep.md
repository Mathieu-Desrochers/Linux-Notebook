grep
----
Print lines matching a pattern.

Creating the test files
-----------------------
Run the following commands:

    $ cat > potions << "EOF"
    ruby
    pink
    orange
    EOF

    $ mkdir folder
    $ cat > folder/wands << "EOF"
    glass
    balsa
    crystal
    EOF

Demonstration
-------------
Searching within a file:

    $ grep '[aeiouy]n' potions
    pink
    orange

Printing the matching line numbers:

    $ grep -n 'pink' potions
    2:pink

Inverting the matching lines:

    $ grep -v 'pink' potions
    ruby
    orange

Printing only the number of matching lines:

    $ grep -c '[aeiouy]n' potions
    2

Printing only the name of matching files:

    $ grep -l 'pink' *
    potions

Searching recursively:

    $ grep -r 'a' *
    folder/wands:glass
    folder/wands:balsa
    folder/wands:crystal
    potions:orange

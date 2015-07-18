make
----
Maintain program dependencies.

Preparing the demonstration files
---------------------------------
Run the following commands:

    $ cat > part1.txt << EOF
    ZELGO MER
    JUYED AWK YACC
    NR 9
    EOF

    $ cat > part2.txt << EOF
    XIXAXA XOXAXA XUXAXA
    PRATYAVAYAH
    EOF

Defining how to make a file
---------------------------
Run the following commands:

    $ TAB="$(printf '\t')"

    $ cat > makefile << EOF
    whole.txt: part1.txt part2.txt
    ${TAB}cat part1.txt part2.txt > whole.txt
    EOF

What is defined above:

- whole.txt is made from part1.txt and part2.txt
- the command to make whole.txt is cat

Run the following commands:

    $ make whole.txt
    cat part1.txt part2.txt > whole.txt

    $ cat whole.txt
    ZELGO MER
    JUYED AWK YACC
    NR 9
    XIXAXA XOXAXA XUXAXA
    PRATYAVAYAH

Demonstrating dependency tracking
---------------------------------
Run the following command a second time:

    $ make whole.txt
    make: `whole.txt' is up to date.

Make compares the timestamps of whole.txt, part1.txt and part2.txt.  
Since whole.txt is older than all of its dependencies, there is no need to make it again.

Run the following commands:

    $ touch part1.txt

    $ make whole.txt
    cat part1.txt part2.txt > whole.txt

Demonstrating hierarchical dependencies
---------------------------------------
Run the following commands:

    $ TAB="$(printf '\t')"

    $ cat > makefile << EOF
    whole.txt.gz: whole.txt
    ${TAB}gzip -k whole.txt

    whole.txt: part1.txt part2.txt
    ${TAB}cat part1.txt part2.txt > whole.txt
    EOF

A made file may itself be a dependency to another file.

Run the following commands:

    $ touch part1.txt

    $ make whole.txt.gz
    cat part1.txt part2.txt > whole.txt
    gzip -k whole.txt

Defining lists of files
-----------------------
Run the following commands:

    $ TAB="$(printf '\t')"
    $ DOLLAR="$(printf '$')"

    $ cat > makefile << EOF
    PARTS = part1.txt part2.txt

    whole.txt: ${DOLLAR}(PARTS)
    ${TAB}cat ${DOLLAR}(PARTS) > whole.txt
    EOF

Then run the following commands:

    $ touch part1.txt

    $ make whole.txt
    cat part1.txt part2.txt > whole.txt

Defining generic rules
----------------------
Run the following commands:

    $ TAB="$(printf '\t')"
    $ DOLLAR="$(printf '$')"

    $ cat > makefile << EOF
    all: part1.gz part2.gz

    %.gz: %.txt
    ${TAB}gzip -k ${DOLLAR}< > ${DOLLAR}@
    EOF

What is defined above:

- making all means making part1.gz and part2.gz
- the command to make a gz file from its txt file is gzip
- the $< construct is replaced by the dependent file
- the $@ construct is replaced by the made file

Run the following command:

    $ make all
    gzip -k part1.txt > part1.gz
    gzip -k part2.txt > part2.gz

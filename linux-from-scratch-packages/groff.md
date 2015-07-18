groff
-----
Document formatting system.

Creating a man page
-------------------
Run the following commands:

    $ cat > dance.man << EOF
    .TH DANCE 1 "2015-03-12" "1.0" "User commands"
    .SH NAME
    dance \- Makes you dance
    .SH SYNOPSIS
    \fBdance\fR [ -f | -l ]
    .SH DESCRIPTION
    dance is a rarely used command that makes programmers move in strange ways.
    .SH OPTIONS
    .TP
    \fB-f\fR makes you dance fast
    .TP
    \fB-l\fR makes you dance languorously (use with caution)
    .SH AUTHOR
    Your's Truly (alias@server.com)
    EOF

Summary of the macros used:

- .TH: Manual header
- .SH: Section header
- .TP: Bulleted paragraph
- /fB: Bold font
- /fR: Roman font

Displaying the man page
-----------------------
Run the following commands:

    $ man ./dance.man

Installing the man page
-----------------------
Run the following commands:

    $ sudo cp dance.man /usr/share/man/man1/dance.1
    $ sudo gzip /usr/share/man/man1/dance.1
    $ man dance

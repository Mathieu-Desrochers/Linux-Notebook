automake
--------
Generate Makefile.in for configure from Makefile.am.

Creating the program to compile
-------------------------------
Run the following command:

    $ cat > main.c << "EOF"
    #include <stdio.h>

    int main (void)
    {
      puts("Test");
      return 0;
    }
    EOF

Creating the automake instructions
----------------------------------
Run the following command:

    $ cat > Makefile.am << "EOF"
    bin_PROGRAMS = test
    test_SOURCES = main.c
    EOF

Creating the automake script
----------------------------
Run the following command:

    $ cat > configure.ac << "EOF"
    echo "-----------------------------------------------"
    echo "Initializing autoconf"
    echo "-----------------------------------------------"
    AC_INIT([test], [version-0.1])

    echo "-----------------------------------------------"
    echo "Initializing automake"
    echo "-----------------------------------------------"
    AM_INIT_AUTOMAKE([-Wall -Werror foreign])

    echo "-----------------------------------------------"
    echo "Setting C compiler"
    echo "-----------------------------------------------"
    AC_PROG_CC

    echo "-----------------------------------------------"
    echo "Declaring makefiles to generate"
    echo "-----------------------------------------------"
    AC_CONFIG_FILES([Makefile])

    echo "-----------------------------------------------"
    echo "Writing makefiles"
    echo "-----------------------------------------------"
    AC_OUTPUT
    EOF

Generating the configuration script
-----------------------------------
Run the following command:

    $ autoreconf --install

Compiling the program
---------------------
Run the following commands:

    $ ./configure
    $ make
    $ ./test

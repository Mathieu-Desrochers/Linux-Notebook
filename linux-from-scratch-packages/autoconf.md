autoconf
--------
Generate configuration scripts.

Creating the autoconf script
----------------------------
Run the following command:

    $ cat > configure.ac << "EOF"
    AC_INIT(myconfig, version-0.1)

    echo "-----------------------------------------------"
    echo "Testing C compiler"
    echo "-----------------------------------------------"
    AC_PROG_CC

    echo "-----------------------------------------------"
    echo "Setting C compiler"
    echo "-----------------------------------------------"
    AC_LANG(C)

    echo "-----------------------------------------------"
    echo "Checking header file"
    echo "-----------------------------------------------"
    AC_CHECK_HEADERS(stdio.h)

    echo "-----------------------------------------------"
    echo "Checking library"
    echo "-----------------------------------------------"
    AC_CHECK_LIB(c, strlen)

    echo "-----------------------------------------------"
    echo "Setting output variables"
    echo "-----------------------------------------------"
    if test "$ac_cv_header_stdio_h" == yes
    then
      AC_SUBST(STDIO_PRESENT, "sure")
    else
      AC_SUBST(STDIO_PRESENT, "nope")
    fi

    if test "$ac_cv_lib_c_strlen" == yes
    then
      AC_SUBST(STRLEN_PRESENT, "sure")
    else
      AC_SUBST(STRLEN_PRESENT, "nope")
    fi

    echo "-----------------------------------------------"
    echo "Writing output variables"
    echo "-----------------------------------------------"
    AC_OUTPUT(result)
    EOF

Creating the output template
----------------------------
Run the following command:

    $ cat > result.in << "EOF"
    c compiler: @CC@
    stdio is present: @STDIO_PRESENT@
    strlen is present: @STRLEN_PRESENT@
    EOF

Generating the configuration script
-----------------------------------
Run the following command:

    $ autoconf configure.ac > configure

Running the configuration script
--------------------------------
Run the following commands:

    $ chmod u+x configure
    $ ./configure
    $ cat result

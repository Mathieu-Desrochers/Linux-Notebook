pkg-config
----------
Retrieves information about installed libraries in the system.

Creating the configuration file
-------------------------------
Run the following command:

    $ cat > librestaurant.pc << "EOF"
    prefix=/usr
    includedir=${prefix}/include
    libdir=${prefix}/lib

    Name: librestaurant
    Description: Event driven restaurant library
    Version: 0.1.0
    Cflags: -I${includedir}/librestaurant
    Libs: -L${libdir} -lrestaurant
    Requires: libevent >= 2.0.0
    EOF

Deploy the configuration file as part of the library package,  
inside the following directory:

    /usr/lib/pkgconfig

Generating the required compilation flags
-----------------------------------------
Run the following commands:

    $ pkg-config --cflag librestaurant
    -I/usr/include/librestaurant

    $ pkg-config --libs librestaurant
    -L/usr/lib -lrestaurant -levent

Using the required compilation flags
------------------------------------
Run the following commands:

    $ echo `pkg-config --cflags --libs librestaurant`
    -I/usr/include/librestaurant -L/usr/lib -lrestaurant -levent

    $ gcc `pkg-config --cflags --libs librestaurant` main.c -o main

Checking dependencies
---------------------
Run the following command:

    $ pkg-config --libs "libevent >= 1000"
    Requested 'libevent >= 1000' but version of libevent is 2.0.22-stable

gdb
---
The GNU Debugger.

Compiling the test program
--------------------------
Run the following commands:

    $ cat > test.c << "EOF"
    int main(void)
    {
      int a = 10;
      int b = 5;
      int sum_of_squares = (a * a) + (b * b);
      return 0;
    }
    EOF

    $ gcc -g test.c -o test

Launching the program inside the debugger
-----------------------------------------
Run the following commands:

    $ gdb test
    (gdb) run
    tarting program: /tmp/test
    [Inferior 1 (process 5264) exited normally]

Setting breakpoints
-------------------
Run the following commands:

    (gdb) break test.c:main
    Breakpoint 1 at 0x4004f1: file test.c, line 3.

    (gdb) break test.c:5
    Breakpoint 2 at 0x4004ff: file test.c, line 5.

    (gdb) info breakpoint
    Num     Type           Disp Enb Address            What
    1       breakpoint     keep y   0x00000000004004f1 in main at test.c:3
    2       breakpoint     keep y   0x00000000004004ff in main at test.c:5

    (gdb) disable 2

    (gdb) clear test.c:5
    Deleted breakpoint 2

Stepping through the program
----------------------------
Run the following commands:

    (gdb) run
    Breakpoint 1, main () at test.c:3
    3   int a = 10;

    (gdb) n
    4   int b = 5;

    (gdb) c
    Continuing.
    [Inferior 1 (process 8808) exited normally]

Use s to step into.  
Use n to step over.

Inspecting and assigning variables
----------------------------------
Run the following commands:

    (gdb) run
    Breakpoint 1, main () at test.c:3
    3   int a = 10;

    (gdb) n

    (gdb) print a
    $1 = 10

    (gdb) set variable b = 2

    (gdb) print b
    $2 = 2

Displaying the stack
--------------------
Run the following command:

    (gdb) bt
    #0  main () at test.c:4

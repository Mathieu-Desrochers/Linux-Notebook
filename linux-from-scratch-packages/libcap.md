libcap
------
Capabilities library.

Testing for capabilities
------------------------
Run the following commands:

    $ cat > test.c << "EOF"
    #include <sys/capability.h>

    void main()
    {
      cap_t capabilities = cap_get_proc();

      cap_flag_value_t flag_value;
      cap_get_flag(capabilities, CAP_CHOWN, CAP_EFFECTIVE, &flag_value);

      if (flag_value == CAP_SET)
      {
        puts("I can change the owners!");
      }
      else
      {
        puts("I cannot change the owners...");
      }

      cap_free(capabilities);
    }
    EOF

    $ gcc test.c -lcap -o test

    $ ./test
    I cannot change the owners...

    $ sudo ./test
    I can change the owners!

Being safe and declining unrequired capabalities
------------------------------------------------
Run the following commands:

    $ touch file

    $ cat > test.c << "EOF"
    #include <stdio.h>
    #include <sys/capability.h>

    void main()
    {
      int chown_result = chown("./file", 0, 0);

      printf("chown_result: %d\n", chown_result);

      cap_t capabilities = cap_get_proc();

      cap_clear(capabilities);
      cap_set_proc(capabilities);

      cap_free(capabilities);

      chown_result = chown("./file", 1, 1);

      printf("chown_result: %d\n", chown_result);
    }
    EOF

    $ gcc test.c -lcap -o test

    $ sudo ./test
    chown_result: 0
    chown_result: -1

Granting capabalities in order to avoid sudo
--------------------------------------------
Run the following commands:

    $ touch file2

    $ cat > test.c << "EOF"
    #include <stdio.h>

    void main()
    {
      int chown_result = chown("./file2", 0, 0);
      printf("chown_result: %d\n", chown_result);
    }
    EOF

    $ gcc test.c -lcap -o test

    $ ./test
    chown_result: -1

    $ sudo setcap 'cap_chown+ep' ./test

    $ ./test
    chown_result: 0

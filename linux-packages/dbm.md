dbm
---
The GNU database manager.

Creating the test program
-------------------------
Run the following command:

    $ cat > test.c << "EOF"
    #include <stddef.h>
    #include <string.h>
    #include <sys/stat.h>
    #include <gdbm.h>

    void demonstrate_write();
    void demonstrate_read();

    int main(void)
    {
      demonstrate_write();
      demonstrate_read();
      return 0;
    }
    EOF

Demonstrating writes
--------------------
Run the following command:

    $ cat >> test.c << "EOF"
    void demonstrate_write()
    {
      GDBM_FILE dbf = gdbm_open(
        "test.db",
        0,
        GDBM_WRCREAT,
        S_IRUSR | S_IWUSR,
        NULL);

      datum key;
      key.dptr = "KEY-1";
      key.dsize = strlen("KEY-1") + 1;

      datum content;
      content.dptr = "VALUE-1";
      content.dsize = strlen("VALUE-1") + 1;

      gdbm_store(
        dbf,
        key,
        content,
        GDBM_REPLACE);

      gdbm_close(dbf);
    }
    EOF

Demonstrating reads
-------------------
Run the following command:

    $ cat >> test.c << "EOF"
    void demonstrate_read()
    {
      GDBM_FILE dbf = gdbm_open(
        "test.db",
        0,
        GDBM_READER,
        0,
        NULL);

      datum key;
      key.dptr = "KEY-1";
      key.dsize = strlen("KEY-1") + 1;

      datum content = gdbm_fetch(
        dbf,
        key);

      puts(content.dptr);

      gdbm_close(dbf);
    }
    EOF

Building and running the program
--------------------------------
Run the following commands:

    $ gcc test.c -l gdbm -o test
    $ ./test
    VALUE-1

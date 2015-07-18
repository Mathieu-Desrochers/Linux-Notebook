libpipeline
-----------
Pipeline manipulation library.

Invoking a command
------------------
Run the following commands:

    $ touch file

    $ cat > test.c << "EOF"
    #include <pipeline.h>

    int main()
    {
      pipeline *p = pipeline_new_command_args("cp", "file", "file-copy", NULL);
      pipeline_run(p);

      return 0;
    }
    EOF

    $ gcc test.c -lpipeline -o test

    $ ./test

    $ ls file-copy
    file-copy

Piping commands
---------------
Run the following commands:

    $ touch file

    $ cat > test.c << "EOF"
    #include <pipeline.h>

    int main()
    {
      pipeline *p = pipeline_new();
      pipeline_command_args(p, "ls", "-l", "file", NULL);
      pipeline_command_args(p, "cut", "-d", " ", "-f", "8", NULL);
      pipeline_run(p);

      return 0;
    }
    EOF

    $ gcc test.c -lpipeline -o test

    $ ./test
    11:07

Capturing the pipeline output
-----------------------------
Run the following commands:

    $ touch file

    $ cat > test.c << "EOF"
    #include <pipeline.h>

    int main()
    {
      pipeline *p = pipeline_new();
      pipeline_command_args(p, "ls", "-l", "file", NULL);
      pipeline_want_out(p, -1);
      pipeline_start(p);

      const char *line = NULL;

      while (line = pipeline_readline(p))
      {
        printf("%s", line);
      }

      pipeline_free(p);

      return 0;
    }
    EOF

    $ gcc test.c -lpipeline -o test

    $ ./test
    -rw-rw-r-- 1 root root 0 May 12 11:07 file

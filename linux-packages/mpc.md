mpc
---
C library for the arithmetic of complex numbers.

Creating the demonstration program
----------------------------------
Run the following command:

    $ cat > demo.c << "EOF"
    #include <mpc.h>

    int main()
    {
      mpc_t x;
      mpc_t y;

      mpc_init2(x, 256);
      mpc_init2(y, 256);

      mpc_set_d_d(x, 0, 2, MPC_RNDNN);

      mpc_sqrt(y, x, MPC_RNDNN);

      char *y_string = mpc_get_str(10, 5, y, MPC_RNDNN);

      puts(y_string);

      mpc_free_str(y_string);

      mpc_clear(x);
      mpc_clear(y);

      return 0;
    }
    EOF

Compiling and running the demonstration program
-----------------------------------------------
Run the following commands:

    $ gcc demo.c -lmpc -o demo
    $ ./demo
    (1.0000 1.0000)

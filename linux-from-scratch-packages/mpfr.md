mpfr
----
C library for multiple-precision floating-point computations.

Creating the demonstration program
----------------------------------
Run the following command:

    $ cat > demo.c << "EOF"
    #include <gmp.h>
    #include <mpfr.h>
    #include <stddef.h>
    #include <stdio.h>

    int main()
    {
      mpfr_t x;
      mpfr_t y;
      mpfr_t z;

      mpfr_init2(x, 256);
      mpfr_init2(y, 256);
      mpfr_init2(z, 256);

      mpfr_set_d(x, 1, MPFR_RNDN);
      mpfr_set_d(y, 3, MPFR_RNDN);

      mpfr_div(z, x, y, MPFR_RNDN);

      mpfr_exp_t e;

      char *z_string = mpfr_get_str(NULL, &e, 10, 0, z, MPFR_RNDN);

      printf("0.%s * 10^%d\n", z_string, (int)e);

      mpfr_free_str(z_string);

      mpfr_clear(x);
      mpfr_clear(y);
      mpfr_clear(z);

      return 0;
    }
    EOF

Compiling and running the demonstration program
-----------------------------------------------
Run the following commands:

    $ gcc demo.c -lmpfr -o demo
    $ ./demo
    0.3333333333333333333333333333333333333333333333333333333333333333333333333333348 * 10^0

gmp
---
Multiple precision arithmetic library.

Creating the demonstration program
----------------------------------
Run the following command:

    $ cat > demo.c << "EOF"
    #include <gmp.h>

    int main()
    {
      mpz_t first_integer;
      mpz_t second_integer;
      mpz_t greatest_common_divisor;

      mpz_init_set_str(first_integer, "116368671786395", 10);
      mpz_init_set_str(second_integer, "2819445786714176106", 10);

      mpz_init(greatest_common_divisor);

      mpz_gcd(greatest_common_divisor, first_integer, second_integer);

      gmp_printf("%Zd\n", greatest_common_divisor);

      mpz_clear(first_integer);
      mpz_clear(second_integer);
      mpz_clear(greatest_common_divisor);

      return 0;
    }
    EOF

Compiling and running the demonstration program
-----------------------------------------------
Run the following commands:

    $ gcc demo.c -lgmp -o demo
    $ ./demo
    17

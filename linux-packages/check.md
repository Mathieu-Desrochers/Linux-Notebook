check
-----
A unit testing framework for C.

Defining a test
---------------
Run the following command:

    $ cat > test.c << "EOF"
    #include <check.h>

    START_TEST(addition_test)
    {
      int result = 1 + 2;
      ck_assert_int_eq(result, 3);
    }
    END_TEST
    EOF

Creating a test suite
---------------------
Run the following command:

    $ cat >> test.c << "EOF"
    Suite* create_suite(void)
    {
      TCase* operators_case = tcase_create("operators");
      tcase_add_test(operators_case, addition_test);

      Suite* integer_suite = suite_create("integer");
      suite_add_tcase(integer_suite, operators_case);

      return integer_suite;
    }
    EOF

Invoking the tests
------------------
Run the following command:

    $ cat >> test.c << "EOF"
    int main(void)
    {
      Suite* suite = create_suite();
      SRunner* runner = srunner_create(suite);

      srunner_run_all(runner, CK_NORMAL);

      int number_failed = srunner_ntests_failed(runner);

      srunner_free(runner);

      return (number_failed == 0) ? 0 : -1;
    }
    EOF

Compiling the program
---------------------
Run the following command:

    $ gcc test.c `pkg-config --cflags --libs check` -o test

Running the program
-------------------
Run the following command:

    $ ./test
    Running suite(s): integer
    100%: Checks: 1, Failures: 0, Errors: 0

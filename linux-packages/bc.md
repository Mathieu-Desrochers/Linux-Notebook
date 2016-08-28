bc
--
An arbitrary precision calculator language.

Launching the interpreter
-------------------------
Run the following command:

    $ bc

Setting the scale
-----------------
Type the following commands:

    22 / 7
    3

    scale = 5

    22 / 7
    3.14285

Setting the bases
-----------------
Type the following commands:

    ibase = 10
    obase = 2

    42
    101010

Defining functions
------------------
Type the following commands:

    define fact(x) {
      if (x <= 1) return (1);
      return (fact(x-1) * x);
    }

    fact(50)
    30414093201713378043612608166064768844377641568960512000000000000

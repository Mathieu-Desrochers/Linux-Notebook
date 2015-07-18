diff
----
Compare files line by line.

Demonstrating cmp
-----------------
Run the following commands:

    $ cat > a << "EOF"
    * 1 carton milk
    * 2 loafs of bread
    * 6 bananas
    EOF

    $ cat > b << "EOF"
    * 1 carton milk
    * 2 loafs of white bread
    * 6 bananas
    EOF

    $ cmp a b
    a b differ: byte 30, line 2

Demonstrating diff
------------------
Run the following commands:

    $ diff a b
    2c2
    < * 2 loafs of bread
    ---
    > * 2 loafs of white bread

    $ diff a b --context
    *** a 2015-02-09 10:38:39.780000000 -0500
    --- b 2015-02-09 10:38:46.832000000 -0500
    ***************
    *** 1,3 ****
      * 1 carton milk
    ! * 2 loafs of bread
      * 6 bananas
    --- 1,3 ----
      * 1 carton milk
    ! * 2 loafs of white bread
      * 6 bananas

    $ diff a b --unified
    --- a 2015-02-09 10:38:39.780000000 -0500
    +++ b 2015-02-09 10:38:46.832000000 -0500
    @@ -1,3 +1,3 @@
     * 1 carton milk
    -* 2 loafs of bread
    +* 2 loafs of white bread
     * 6 bananas

    $ diff a b --side-by-side
    * 1 carton milk                     * 1 carton milk
    * 2 loafs of bread                | * 2 loafs of white bread
    * 6 bananas                         * 6 bananas

Demonstrating sdiff
-------------------
Run the following commands:

    $ export EDITOR=vim

    $ sdiff a b -o ab
    * 1 carton milk                     * 1 carton milk
    * 2 loafs of bread                | * 2 loafs of white bread
    %el
    :normal A (white if possible)
    :wq
    * 6 bananas                         * 6 bananas

    $ cat ab
    * 1 carton milk
    * 2 loafs of bread (white if possible)
    * 6 bananas

Demonstrating diff3
-------------------
Run the following commands:

    $ cat > c << "EOF"
    * 1 carton milk
    * 2 loafs of whole grain bread
    * 6 bananas
    EOF

    $ diff3 b a c
    ====
    1:2c
      * 2 loafs of white bread
    2:2c
      * 2 loafs of bread
    3:2c
      * 2 loafs of whole grain bread

Demonstrating merge
-------------------
Run the following commands:

    $ merge -A b a c
    merge: warning: conflicts during merge

    $ cat b
    * 1 carton milk
    <<<<<<< b
    * 2 loafs of white bread
    ||||||| a
    * 2 loafs of bread
    =======
    * 2 loafs of whole grain bread
    >>>>>>> c
    * 6 bananas

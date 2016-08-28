patch
-----
Apply a diff file to an original.

Creating a patch for a file
---------------------------
Run the following commands:

    $ cat > original << "EOF"
    * 1 carton milk
    * 2 loafs of bread
    * 6 bananas
    EOF

    $ cat > modified << "EOF"
    * 1 carton milk
    * 2 loafs of white bread
    * 6 bananas
    EOF

    $ diff -u original modified > original.patch

    $ rm modified

Applying a patch to a file
--------------------------
Run the following commands:

    $ patch < original.patch
    patching file original

    $ cat original
    * 1 carton milk
    * 2 loafs of white bread
    * 6 bananas

Creating a patch for a directory
--------------------------------
Run the following commands:

    $ mkdir sources
    $ cat > sources/main.c << "EOF"
    int main()
    {
    }
    EOF

    $ mkdir sources.modified
    $ cat > sources.modified/main.c << "EOF"
    int main()
    {
      return 0;
    }
    EOF

    $ diff -u -r sources/ sources.modified/ > sources.patch

    $ rm -r sources.modified

Applying a patch to a directory
-------------------------------
Run the following commands:

    $ cd sources
    $ patch -p1 < ../sources.patch
    patching file main.c

    $ cat main.c
    int main()
    {
      return 0;
    }

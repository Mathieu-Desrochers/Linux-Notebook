flex
----
Fast lexical analyser generator.

Creating the script
-------------------
Run the following command:

    $ cat > words.lex << "EOF"
      int small_words_count = 0;
      int big_words_count = 0;

    %%

    [a-zA-Z]{1,4}   { small_words_count++; }
    [a-zA-Z]{5,}    { big_words_count++; }
    .               { ; }

    %%

    int yywrap()
    {
      return 1;
    }

    int main()
    {
      yylex();

      printf("Small words count: %d\n", small_words_count);
      printf("Big words count: %d\n", big_words_count);

      return 0;
    }
    EOF

Compiling the program
---------------------
Run the following commands:

    $ lex --outfile=words.yy.c words.lex
    $ cc words.yy.c -o words

Running the program
-------------------
Run the following command:

    $ ./words
    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore
    CTRL+D
    Small words count: 6
    Big words count: 9

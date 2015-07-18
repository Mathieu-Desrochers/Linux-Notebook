bison
-----
An LALR(3) parser generator.

Defining the lex tokens
-----------------------
Run the following command:

    $ cat > calc.lex << "EOF"
    %{
    #include <stdlib.h>
    #include "calc.tab.h"
    %}

    %%

    [0-9]+        { yylval = atoi(yytext); return INTEGER; }
    [\+\-\n]      { yylval = *yytext; return *yytext; }
    [ ]           { ; }

    %%

    int yywrap(void) {
      return 1;
    }
    EOF

Defining the yacc syntax
------------------------
Run the following command:

    $ cat > calc.y << "EOF"
    %{
    #include <stdio.h>
    void yyerror(char *);
    %}

    %token INTEGER

    %%

    program:
              program expr '\n'       { printf("%d\n", $2); }
              |
              ;

    expr:
              INTEGER                 { $$ = $1; }
              | expr '+' INTEGER      { $$ = $1 + $3; }
              | expr '-' INTEGER      { $$ = $1 - $3; }
              ;

    %%

    void yyerror(char *s) {
      fprintf(stderr, "%s\n", s);
    }

    int main(void) {
      yyparse();
      return 0;
    }
    EOF

Compiling the program
---------------------
Run the following commands:

    $ lex --outfile=calc.yy.c calc.lex
    $ yacc -d --file-prefix=calc calc.y
    $ cc calc.yy.c calc.tab.c -o calc

Running the program
-------------------
Run the following command:

    $ ./calc
    1 + 2
    3

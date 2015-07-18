expat
-----
Expat is an XML parser library written in C.

Creating the program
--------------------
Run the following command:

    $ cat > expat.c << "EOF"
    #include <stdio.h>
    #include <string.h>
    #include "expat.h"

    void start_element_handler(void *user_data, const char *name, const char **attributes)
    {
      if (strncmp(name, "scroll", strlen("scroll") + 1) == 0)
      {
        puts(attributes[1]);
      }
    }

    void end_element_handler(void *user_data, const char *name)
    {
    }

    int main()
    {
      XML_Parser parser = XML_ParserCreate(NULL);
      if (parser == NULL)
      {
        puts("Life sucks...");
        exit(-1);
      }

      XML_SetElementHandler(
        parser,
        start_element_handler,
        end_element_handler);

      char* xml = ""
        "<scrolls>"
        "  <scroll appearance=\"HACKEM MUCHE\">"
        "  <scroll appearance=\"LEP GEX VEN ZEA\">"
        "  <scroll appearance=\"READ ME\">"
        "</scrolls>";

      XML_Parse(
        parser,
        xml,
        strlen(xml),
        1);

      return 0;
    }
    EOF

Building and running the program
--------------------------------
Run the following commands:

    $ gcc expat.c -lexpat -o expat
    $ ./expat
    HACKEM MUCHE
    LEP GEX VEN ZEA
    READ ME

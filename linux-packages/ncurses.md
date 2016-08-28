ncurses
-------
The ncurses library routines give the user a terminal-independent method of updating character screens.

Creating the program
--------------------
Run the following command:

    $ cat > test.c << "EOF"
    #include <stdlib.h>
    #include <ncurses.h>
    #include <form.h>

    int main()
    {
      initscr();

      cbreak();
      nonl();
      noecho();

      FIELD **fields = malloc(sizeof(FIELD *) * 3);
      fields[0] = new_field(1, 20, 1, 18, 0, 0);
      fields[1] = new_field(1, 20, 2, 18, 0, 0);
      fields[2] = NULL;

      set_field_back(fields[0], A_UNDERLINE);
      set_field_back(fields[1], A_UNDERLINE);

      set_field_type(fields[1], TYPE_INTEGER, 0, 0, 0);

      FORM *form = new_form(fields);
      post_form(form);
      refresh();

      mvprintw(1, 2, "Full name:");
      mvprintw(2, 2, "Age (numeric):");
      move(1, 18);

      set_current_field(form, fields[0]);
      refresh();

      int enter_pressed = 0;

      while (enter_pressed == 0)
      {
        int character = getch();

        switch (character)
        {
          case 9:
            form_driver(form, REQ_NEXT_FIELD);
            form_driver(form, REQ_END_LINE);
            break;

          case 13:
            enter_pressed = 1;
            break;

          case 127:
            form_driver(form, REQ_DEL_PREV);
            break;

          default:
            form_driver(form, character);
            break;
        }
      }

      form_driver(form, REQ_VALIDATION);

      char *full_name = field_buffer(fields[0], 0);

      mvprintw(4, 2, "Welcome ");
      mvprintw(4, 10, full_name);
      move(5, 2);

      refresh();
      getch();

      unpost_form(form);

      free_form(form);
      free_field(fields[0]);
      free_field(fields[1]);

      free(fields);

      endwin();

      return 0;
    }
    EOF

Building and running the program
--------------------------------
Run the following commands:

    $ gcc test.c -lform -lncurses -o test
    $ ./test

      Full name:      Mathieu_____________
      Age (numeric):  99__________________

      Welcome Mathieu

Writing a correct C function
============================
Immensely inspired by Zed's Amazing Debug Macros.
If anything read only this page:

    http://c.learncodethehardway.org/book/ex20.html

Defining the signature
----------------------
Use the following guidelines:

- Return an integer to indicate success with 0
- Begin the function name with a module prefix then additional context
- End of the function name with the accomplished action
- First list the input parameters
- Then the output parameters

Example:

    // opens a sql connection
    int sql_connection_open(char *filename, sqlite3 **sql_connection);

Declaring temporary return variables
------------------------------------
Use the following guidelines:

- Do not assign to the return parameters until everything has succeeded
- Declare temporary variables ending with return
- Initialize these variables

Example:

    sqlite3 *sql_connection_return = NULL;

Checking the input parameters
-----------------------------
Use the following guidelines:

- Validate every input parameter
- Validate that the output parameters are not null

Example:

    check(filename != NULL, "filename: NULL");
    check(sql_connection != NULL, "sql_connection: NULL");

Validating the return value of other function calls
---------------------------------------------------
Use the following guidelines:

- Each and every function call must be validated
- Assign the return value to a variable whose name ends with result
- Print out the function name on error
- Also list the parameter values

Examples:

    char *allocated_resource = malloc(sizeof(char) * 100);
    check_mem(allocated_resource);

    int sqlite3_open_result = sqlite3_open_v2(filename, &sql_connection_return, SQLITE_OPEN_READWRITE, NULL);
    check(sqlite3_open_result == SQLITE_OK, "sqlite3_open_result: %d | filename: %s",
      sqlite3_open_result, filename);

Signaling success
-----------------
Use the following guidelines:

- Free the allocated resources that will not be returned
- Only assign to the return parameters now
- Return 0 to indicate success

Example:

    free(allocated_resource);

    *sql_connection = sql_connection_return;

    return 0;

Handling errors
---------------
Use the following guidelines:

- Free all the allocated resources
- Do not touch the output parameters
- Return -1 to indicate an error

Example:

    if (allocated_resource != NULL) { free(allocated_resource); }
    if (sql_connection_return != NULL) { sqlite3_close(sql_connection_return); }

    return -1;

Proving correct memory management
---------------------------------
Use the following guidelines:

- Prepare a program that invokes the function
- The values sent to the function are not important
- Except if specific values are required to enter certain branches
- Place a failing check after every existing check
- Recompile and feed in to valgrind
- Confirm no memory was leaked

Example:

    int sqlite3_open_result = sqlite3_open_v2(filename, &sql_connection_return, SQLITE_OPEN_READWRITE, NULL);
    check(sqlite3_open_result == SQLITE_OK, "sqlite3_open_result: %d | filename: %s",
      sqlite3_open_result, filename);

    check_mem(NULL);

Generalized pattern
-------------------
The following boilerplate code does the following:

- Respects the above guidelines
- Removes duplicated code for freeing resources

Example:

    int module_do_stuff(void **a, void **b)
    {
        void *a_return = NULL;
        void *b_return = NULL;

        int exit_code = 0;

        void *a_local = NULL;
        void *b_local = NULL;

        check(a != NULL, "a: NULL");
        check(b != NULL, "b: NULL");

        // body with everything under check()
        // malloc is only allowed from here on
        // assiging to the return parameters
        // is still forbidden though

        *a = a_return;
        *b = b_return;

        goto cleanup;

    error:

        if (a_return != NULL) { free(a_return); }
        if (b_return != NULL) { free(b_return); }

        exit_code = -1;

    cleanup:

        if (a_local != NULL) { free(a_local); }
        if (b_local != NULL) { free(b_local); }

        return exit_code;
    }

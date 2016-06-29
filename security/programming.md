Compiling a test program
------------------------
Run the following commands.

    $ cat > main.c << EOF
    #include <stdio.h>

    int main()
    {
      int i;
      for (i = 0; i < 10; i++)
      {
        printf("Hello\n");
      }
      return 0;
    }
    EOF

    $ gcc main.c -o main

Realizing it's all assembly in the end
--------------------------------------
Run the following command.

    $ objdump -M intel -d main
    ...
    0000000000400628 <main>:
      400628:       55                      push   rbp
      400629:       48 89 e5                mov    rbp,rsp
      40062c:       48 83 ec 10             sub    rsp,0x10
      400630:       c7 45 fc 00 00 00 00    mov    DWORD PTR [rbp-0x4],0x0
      400637:       eb 0e                   jmp    400647 <main+0x1f>
      400639:       bf 2c 07 40 00          mov    edi,0x40072c
      40063e:       e8 6d fe ff ff          call   4004b0 <puts@plt>
      400643:       83 45 fc 01             add    DWORD PTR [rbp-0x4],0x1
      400647:       83 7d fc 09             cmp    DWORD PTR [rbp-0x4],0x9
      40064b:       7e ec                   jle    400639 <main+0x11>
      40064d:       b8 00 00 00 00          mov    eax,0x0
      400652:       c9                      leave
      400653:       c3                      ret
    ...

This is only memory containing data, some of which represent instructions.  
Add a processor to read/write that memory and execute these instructions,  
and there is your computer.

Debugging assembly
------------------
Run the following commands.

    $ gdb ./main

    (gdb) set disassembly-flavor intel

    (gdb) break main
    Breakpoint 1 at 0x40062c

    (gdb) run
    Breakpoint 1, 0x000000000040062c in main ()

    (gdb) disassemble main
    Dump of assembler code for function main:
       0x0000000000400628 <+0>:     push   rbp
       0x0000000000400629 <+1>:     mov    rbp,rsp
    => 0x000000000040062c <+4>:     sub    rsp,0x10
       0x0000000000400630 <+8>:     mov    DWORD PTR [rbp-0x4],0x0
       0x0000000000400637 <+15>:    jmp    0x400647 <main+31>
       0x0000000000400639 <+17>:    mov    edi,0x40072c
       0x000000000040063e <+22>:    call   0x4004b0 <puts@plt>
       0x0000000000400643 <+27>:    add    DWORD PTR [rbp-0x4],0x1
       0x0000000000400647 <+31>:    cmp    DWORD PTR [rbp-0x4],0x9
       0x000000000040064b <+35>:    jle    0x400639 <main+17>
       0x000000000040064d <+37>:    mov    eax,0x0
       0x0000000000400652 <+42>:    leave
       0x0000000000400653 <+43>:    ret
    End of assembler dump.

Instructions take the following form:

    operation <destination>, <source>

Inspecting memory
-----------------


Modes
-----

i: insert mode (before current character)  
I: insert mode (before first non blank character)  
a: insert mode (after current character)  
A: insert mode (end of line)  
s: insert mode (deletes current character)  
S: insert mode (deletes current line)  
C: insert mode (deletes rest of line)  

C-o: insert normal mode (one off)  

R: replace mode  

v: visual mode  
V: visual mode (line)  
C-v: visual mode (block)  
gv: visual mode (last selection)  

:: command line mode  

Operators
---------

c: change (uppercase to end of line)  
d: delete (uppercase to end of line)  
y: yank  

r: replace character  
g~: swap case  
gu: make lowercase  
gU: make uppercase  

>: shift right  
<: shift left  
=: autoindent  

!: filter through external program  

Motions
-------

h: left one character  
j: down one line  
k: up one line  
l: right one character  

w: next word start (uppercase ignores punctuation)  
b: previous word start (uppercase ignores punctuation)  
e: next word end (uppercase ignores punctuation)  

0: first character of the line  
^: first non-blank character of the line  
$: last character of the line  

f: next occurrence of a character on the line  
F: previous occurrence of a character on the line  
t: until next occurrence of a character on the line  
T: until previous occurence of a character on the line  
;: repeat last f, F, t or T in the same direction  
,: repeat last f, F, t or T in the opposite direction  

gg: goto first line  
G: goto line, last by default  

/: search counts as a motion  

Grammar
-------

syntax: count + operator + count + motion  
shotcut: count + operator + operator (current line)  

Text objects
------------

i: inside pending object  
a: around pending object  

w: word object  
p: paragraph object  
": double quotes object  
): parenthese object  
]: square bracket object  
}: curly bracket object  

Navigation
----------

ctrl-b: up one screen  
ctrl-u: up one half-screen  
ctrl-d: down one half-screen  
ctrl-f: down one screen  

zz: center current line in the middle of screen  

{: start of current paragraph  
}: end of current paragraph  

%: matching (, [ or {  

C-o: jump previous location  
C-i: jump next location  

ma: sets mark a (uppercase letter cross buffers)  
`a: jump to mark a  

Normal mode
-----------

@:: repeat last ex command  

Insert mode
-----------

C-u: delete previous word  
C-w: delete to start of line  

C-r0: paste from of register 0  
C-r=: paste from expression register  

Visual mode
-----------

I: insert before each line of block  
A: append after each line of block  

o: toggle end of block  

Command line grammar
--------------------

range:  
address [offset] [, [address [offset]]]  

address:  
1: line number 1  
.: current line  
0: start of file  
$: end of file  
%: whole file  
/pattern/: search result location  
`m: mark m  

offset:  
{+|-}n  

Command line mode
-----------------

[range] delete [x]: delete lines to register x  
[range] yank [x]: yank lines to register x  
[line] put x: put register x after line  

[range] copy address: copy lines  
[range] move address: move lines  
[range] normal x: run normal command x on every line  
[range] join: join lines  

read !x: put shell command x output  
[range] write !x: invoke shell command x with every line  
[range] !x: filters range through shell command x  

!x: execute shell command x  
!x %: current buffer name as parameter  

Tab: cycle through autocompleted commands  
C-d: suggest autocompleted commands  

C-r0: paste from of register 0  
C-r=: paste from expression register  
C-w: paste current word  

q:: open command line window from normal mode  
C-f: open command line window from command line mode  
Enter: execute command  

Buffers
-------

:ls: list buffers (%visible, #alternate, +dirty)  
C-^: toggle between visible and alternate  

:bnext: next buffer  
:bprevious: previous buffer  
:bdelete N: delete buffer N  

Argument list
-------------

:args: shows argument list ([active])   
:args glob: load files in argument list  
:args `cat myfiles`: loat files by backtick expansion  

:next: next file in argument list  
:previous: previous file in argument list  

:argdo x: execute command x on every file in argument list  

Split windows
-------------

C-ws: horizontal split  
C-wv: vertical split  

C-ww: cycle through windows  
C-w[h|j|k|l]: cycle to left|bottom|up|right window   
C-wT: move window to new tab page  

:close: close window  
:only: close other windows  

Tab pages
---------

:tabedit: new tab page  
:tabedit file: edit file in new tab page  

gt: next tab page  
Ngt: tab page by number  
gT: previous tab page  

:tabclose: close tab page  
:tabonly: close other tab pages  

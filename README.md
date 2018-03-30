# compilers-3005
<i>A bunch of lex and yacc codes, written as a part of Compilers Lab coursework (under the the tutelage of Mr.B.Thanashekar, Asst. Professor, Anna University)</i>

<b>Folders and their descriptions:</b>

01: Symbol Table creation for simple variable declarations. <br/>
02: Conversion of if-statements to if-else statements<br/>
03: Conversion of do-while loops and for-loops to while-loops<br/>
04: Creation of syntax tree for a given expression and printing its postfix representation <br/>
05: Generation of 3-address statements for simple expressions, and assignment statements<br/>
06: Generation of 3-address statements for more complex expressions, involving declaration-checking, symbol table, array representations and back-patching<br/>
07: Generation of basic blocks using the 'leaders' algorithm and constructing the flow graph from it<br/>
09: Code Generation from labelled trees <br/>

<b>How to compile: </b>

Some lex-yacc files have been written in C, while some are written in C++. The respective compilations for each language are:

<i>C compilation</i><br/>
lex a.l<br/>
yacc -d a.y<br/>
cc lex.yy.c y.tab.c<br/>
./a.out < [Enter name of your input file]<br/>


<i>C++ compilation</i><br/>
lex a.l<br/>
yacc -d a.y <br/>
g++ lex.yy.c y.tab.c -lfl<br/>
./a.out < [Enter name of your input file]<br/>

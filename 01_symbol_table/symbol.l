%{
	#include<stdio.h>
	#include "y.tab.h"
	int x=0;
%}

%%
"int" 			{x++;return INT;}
"float" 		{x++;return FLOAT;}
"char" 			{x++; return CHAR;}
"double" 		{x++;return DOUBLE;}
[a-z]+ 			{yylval=yytext;if(x>0) {return ID;} return 0;}
"," 			return C;
[\n\t ]+ 		/*ignore*/;
";" 			{x--;return SEMICOLON;}
"{"				return OPENBRACE;
"}"				return CLOSEBRACE;
%%
%{
	#include<stdio.h>
	#include "y.tab.h"
%}

%% 	
if    						{return IF;}
else  				    	{return ELSE;}
"(" 						{return OP;}
")" 						{return CL;}
"{" 						{return OPENBRACE;}
"}" 						{return CLOSEBRACE;}
[ \t\n] 					{printf("%s",yytext); ;}
[0-9a-zA-Z><+-=*/%&|!;]+	{return STATEMENT;}
.   						{return yytext[0];}
%%
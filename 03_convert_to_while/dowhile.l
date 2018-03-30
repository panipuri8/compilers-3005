%{
	#include<stdio.h>
	#include "y.tab.h"
%}


%%
"do" 							yylval.str=strdup(yytext);return DO;
"while"							yylval.str=strdup(yytext);return WHILE;
"{" 							yylval.str=strdup(yytext);return OPENBRACE;
"}" 							yylval.str=strdup(yytext);return CLOSEBRACE;
"(" 							yylval.str=strdup(yytext);return OPEN;
")" 							yylval.str=strdup(yytext);return CLOSE;
";" 							yylval.str=strdup(yytext);return SEMICOLON;
([0-9a-zA-Z><+\-=*/%&|!,]" "?)+	yylval.str=strdup(yytext);return STATEMENT;
\n        						;  
[ ]+    						/*ignore*/  ;
[\t]+							;
. 								;
%%
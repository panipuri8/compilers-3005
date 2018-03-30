%{
	#include<stdio.h>
	#include<stdlib.h>	
	extern char* yytext;
%}

%token FOR OPEN CLOSE OPENBRACE CLOSEBRACE STATEMENT SEMICOLON

%type <str> S FOR OPEN CLOSE OPENBRACE CLOSEBRACE STATEMENT SEMICOLON FORLINE STATE STATEIN

%union{
	char *str;
}

%%
S : FORLINE OPENBRACE STATEIN S STATEIN CLOSEBRACE {printf("%s\n",$6);} S| FORLINE OPENBRACE STATEIN CLOSEBRACE {printf("%s\n",$4);}  S| {};
FORLINE : FOR OPEN STATE SEMICOLON STATE SEMICOLON STATE CLOSE {printf("%s;\n while(%s) {\n %s;\n",$3,$5,$7); };
STATE : STATEMENT | {} ;
STATEIN : STATEMENT SEMICOLON STATEIN {printf("%s %s \n",$1,$2);}|  {};
%%

int yyerror(char* s) {
	printf("There was a %s\n",s);
}

int yywrap() {
	return 1;
}

main() {
	printf("Enter the exp \n");
	yyparse();
}
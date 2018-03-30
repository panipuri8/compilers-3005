%{
	#include <stdio.h>
	#include <stdlib.h>
	extern char* yytext;
%}

%token IF ELSE OP CL OPENBRACE CLOSEBRACE STATEMENT

%%
S      : ST {printf("\n***VALID!***\n");};
ST     : IF {printf("%s",yytext);} OP{printf("%s",yytext);} STATEMENT {printf("%s",yytext);} CL {printf("%s",yytext);} OPENBRACE{printf("%s",yytext);} ST CLOSEBRACE{printf("%s",yytext);} ELSEPART ST | STATEMENT{printf("%s",yytext);} |   ;
ELSEPART : ELSE{printf("%s",yytext);} OPENBRACE{printf("%s",yytext);} ST CLOSEBRACE {printf("%s",yytext);} | {printf("else{} \n");}  ;
%%

int yyerror(char* s) {
  printf("There was a %s\n",s);
}

int yywrap() {
	return 1;
}

main()
{
  printf("Enter the exp: \n");
  yyparse();
}
%{
	#include<stdio.h>
	#include<stdlib.h>
	extern char* yytext;
	int yyerror(char*);
	int yylex();
	int yywrap();
%}

%token DO OPENBRACE CLOSEBRACE OPEN CLOSE STATEMENT SEMICOLON WHILE

%type<str> DO OPENBRACE CLOSEBRACE OPEN CLOSE STATEMENT SEMICOLON WHILE INSIDE CONDITION STATE ST S

%union {
	char* str;
}

%%
ST : S {printf("%s\n",$1);} ST | S | {};
S : DO OPENBRACE STATE CLOSEBRACE WHILE OPEN CONDITION CLOSE SEMICOLON {
							char* full = (char *)malloc(sizeof(char)*500);
							strcpy(full,$3);
							strcat(full,$5);
							strcat(full,$6);
							strcat(full,$7);
							strcat(full,$8);
							strcat(full,strcat($2,"\n")); 
							strcat(full,strcat($3,"\n"));
							strcat(full,$4);
							$$ = full;
							free(full);
							}| {$$="";};
CONDITION : STATEMENT ;
STATE : STATEMENT SEMICOLON STATE {$$=strcat($1,strcat($2,$3));} | {$$="";} | S {$$=$1;};
%%


int yyerror(char* s) {
	printf("There was a %s\n",s);
}

int yywrap() {
	return 1;
}

main() {
	printf("Enter the exp \n");
	//cout << "HEY" << endl;
	yyparse();
}
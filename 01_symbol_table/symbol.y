%{
	#include<stdio.h>
	#include<string.h>
	int err_no=0,fl=0,i=0,j=0,type[100];
	char symbol[100][100],temp[100];
%}

%token INT FLOAT CHAR DOUBLE ID C SEMICOLON OPENBRACE CLOSEBRACE

%%
START:	S1 {return 1;};
S1:		S OPENBRACE S1 CLOSEBRACE| S S1 | S;
S: 		INT L1 SEMICOLON | FLOAT L2 SEMICOLON | CHAR L3 SEMICOLON | DOUBLE L4 SEMICOLON |INT L1 SEMICOLON S | FLOAT L2 SEMICOLON S | 
				CHAR L3 SEMICOLON S | DOUBLE L4 SEMICOLON S;
L1:		L1 C ID{strcpy(temp,(char *)$3); insert(0);}|ID{strcpy(temp,(char *)$1); insert(0);};
L2:		L2 C ID{strcpy(temp,(char *)$3); insert(1);}|ID{strcpy(temp,(char *)$1); insert(1);};
L3:		L3 C ID{strcpy(temp,(char *)$3); insert(2);}|ID{strcpy(temp,(char *)$1); insert(2);};
L4:		L4 C ID{strcpy(temp,(char *)$3); insert(3);}|ID{strcpy(temp,(char *)$1); insert(3);};
%%

int yyerror(char *str) {
	printf("There was an error.");
	return 0;
}

int yywrap() {
	return 1;
}

void insert(int type1) {
	fl=0;
 	for(j=0;j<i;j++) {
		if(strcmp(temp,symbol[j])==0) {
			if(type[j]==type1) {
				printf("Redeclaration of variable -> %s\n",temp);
			}
			else {
				printf("Multiple Declaration of Variable\n");
				err_no=1;
			}
			fl=1;
		}
	}
	if(fl==0) {
		type[i]=type1;
		strcpy(symbol[i],temp);
		i++;
	}
}

int main() {
	yyparse();
	if(err_no==0) {
		for(j=0;j<i;j++) {
			if(type[j]==0) printf("INT ");
			if(type[j]==1) printf("FLOAT ");
			if(type[j]==2) printf("CHAR ");
			if(type[j]==3) printf("DOUBLE ");
			printf("%s\n",symbol[j]);
		}
	}
	return 0;
}

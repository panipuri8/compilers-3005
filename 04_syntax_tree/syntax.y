%{
	#include<stdio.h>
	#include<stdlib.h>	
	extern char* yytext;

	typedef struct NODE{
		struct NODE *left, *right;
		char* val;
	} node;
	
	node* makeNode(char* val,struct node* left,struct node* right) {
		node* newNode = (node *)malloc(sizeof(node));
		newNode->val = val;
		newNode->left = left;
		newNode->right = right;
		return newNode;
	}

	void postOrder(node* root) {
		if(root != NULL) {
			postOrder(root->left);
			postOrder(root->right);
			printf("%s ",root->val);
		}
	}
%}

%token OPEN CLOSE ADD MUL VARIABLE DIV SUB

%type <str> OPEN CLOSE ADD MUL VARIABLE DIV SUB
%type <myNode> E T F ST

%union{
	struct node *myNode;
	char *str;
}

%%
ST : E {printf("Valid!!!\n"); postOrder($1); printf("\n"); };
E : E ADD T {$$=makeNode("+",$1,$3);} | E SUB T {$$=makeNode("-",$1,$3);} | T {$$=$1;};
T : T MUL F {$$=makeNode("*",$1,$3);} | T DIV F {$$=makeNode("/",$1,$3);} | F {$$=$1;};
F : OPEN E CLOSE {$$=$2;}| VARIABLE {$$=makeNode($1,NULL,NULL);};
%%

int yyerror(char* s) {
	printf("There was a %s\n",s);
}

int yywrap() {
	return 1;
}

int main() {
	printf("Enter the exp \n");
	yyparse();


	/*printf("\n***CHECK***\n");
	node* root = makeNode("*" ,NULL, NULL);
	root->left = makeNode("a" ,NULL, NULL);
	root->right = makeNode("b" ,NULL, NULL);
	postOrder(root);*/

	return 0;
}
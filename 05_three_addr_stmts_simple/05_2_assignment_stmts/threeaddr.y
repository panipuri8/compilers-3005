%{
	#include<bits/stdc++.h>	
	using namespace std;
	extern char* yytext;

	typedef struct NODE{
		struct NODE *left, *right;
		char* val;
	} node;

	int currentInstructionNumber = 0;

	int nextInstruction() {
		return currentInstructionNumber++;
	}

	string to_string(int n) {
		if(n==0) {
			return "0";
		}
		string x = "";
		while(n) {
			x = x + char(n%10 + 48);
			n/=10;
		}
		reverse(x.begin(),x.end());
		return x;	
	}

	stack<string> st;
	
	node* makeNode(char* val,node* left,node* right) {
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
			// cout << root->val << ' ';
			string rootVal = root->val;
			if(rootVal =="+" || rootVal =="-"|| rootVal =="*"|| rootVal=="/") {
				string a = st.top();
				st.pop();
				string b = st.top();
				st.pop();
				string res = "t" + to_string(nextInstruction());
				if(rootVal == "+" || rootVal == "*")
				cout << res << " = " << a << rootVal << b << endl;
				else
				cout << res << " = " << b << rootVal << a << endl;
				st.push(res);
			}
			else {
				string x = rootVal;
				st.push(x);
			}
		}
	}

	void finish_up(char *s) {
		cout<< s << " = " << st.top() << endl;
	}

	int yyerror(char*);
	int yylex();

%}

%token OPEN CLOSE ADD MUL VARIABLE DIV SUB EQ

%type <str> OPEN CLOSE ADD MUL VARIABLE DIV SUB EQ
%type <myNode> E T F ST

%union{
	struct NODE *myNode;
	char *str;
}

%%
ST : VARIABLE EQ E { cout<<"Valid Statement dawdaw!\n"; postOrder($3); finish_up($1); printf("\n"); };
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
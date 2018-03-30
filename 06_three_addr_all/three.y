%{
	#include<bits/stdc++.h>
	using namespace std;
	int yylex();
	void yyerror(char *s);

	int tempC = 1;	int getTemp(){	return tempC++;	}
	int ins = 0;	int getIns(){	return ins++;	}
	string type="";
	int block=-1;
	int basicBlockCount = 0;

	typedef struct Node{
		int ins;
		string type, name, code;
		vector<string> index;
		vector<int> nextList;
		vector<int> trueList, falseList;
	}node;

	node* makeNode(){
		ostringstream s;
		s<<"t"<<getTemp();
		node* temp = new Node();
		temp->code = s.str();
		return temp;
	}

	node* makeNode2(string x){
		node *temp=new node();
		temp->code=x;
		temp->name=x;
		return temp;
	}

	typedef struct NodeDec{
		string type, value;
		vector<string> index;
	}nodedec;

	nodedec* makeNodeDec(){
		nodedec* temp = new NodeDec();
		return temp;
	}

	map<int, map<string, nodedec *> > symboltable;
	map<int, string> instructions;
	set<int> leaders;
	vector< pair<int,int> > leaderLineNo;
	vector< vector<int> > basicBlocks;

	void showBlock(){
		for(int i=0;i<=block;i++){
			for(map<string,nodedec*>::iterator it=symboltable[i].begin();it!=symboltable[i].end();it++){
				cout<<it->first<<" "<<it->second->value<<" "<<it->second->type<<" ";
				for(int k=0;k<it->second->index.size();k++){	cout<<it->second->index[k]<<" ";	}
				cout<<endl;
			}
		}
		symboltable.erase(symboltable.find(block));
		block--;
		cout<<endl<<endl<<endl;
	}

	void checkId(string name){
		for(map<string, nodedec*>::iterator it=symboltable[block].begin();it!=symboltable[block].end();it++){
			if(it->first==name){
				cout<<"Variable "<<name<<" already declared"<<endl;
				exit(0);
			}
		}
	}

	void checkDeclared(string name){
		for(int i=block;i>=0;i--){
			for(map<string,nodedec*>::iterator it=symboltable[i].begin();it!=symboltable[i].end();it++){
				if(it->first==name)	return;
			}
		}
		cout<<name<<" not declared"<<endl;
		exit(0);
	}

	string getType(string name){
		for(int i=block;i>=0;i--){
			for(map<string, nodedec*>::iterator it=symboltable[i].begin();it!=symboltable[i].end();it++){
				if(it->first==name){
					return it->second->type;
				}
			}
		}
		return "";
	}
	vector<string> getIndex(string name){
		for(int i=block;i>=0;i--){
			for(map<string, nodedec*>::iterator it=symboltable[i].begin();it!=symboltable[i].end();it++){
				if(it->first==name){
					return it->second->index;
				}
			}
		}
		vector<string> x;
		return x;
	}

	vector<int> mergeVectors(vector<int> a, vector<int> b){
		vector<int> res(a.begin(),a.end());
		for(int i=0;i<b.size();i++)	res.push_back(b[i]);
		return res;
	}

	void bp(vector<int> a,int num)
	{
		ostringstream ss;
		ss<<num;

		for(vector<int>::iterator it=a.begin();it!=a.end();it++){
			instructions[*it] = instructions[*it]+ss.str();
		}
	}

	bool findBlock(int val){
		for(int i=0;i<leaderLineNo.size();i++){
			if(leaderLineNo[i].second==val){
				return true;
			}
		}
		return false;
	}

	int findBlockNo(int val){
		for(int i=0;i<leaderLineNo.size();i++){
			if(leaderLineNo[i].second==val){
				return leaderLineNo[i].first;
			}
		}
		return -1;
	}

	bool cmp(pair<int,int> a, pair<int,int> b){
		if(a.second<b.second)	return true;
		return false;
	}

	void generate_leaders(){
		leaders.insert(0);
		for(map<int, string>::iterator it=instructions.begin();it!=instructions.end();it++){
			string ins = it->second;
			if((ins[0]=='i' && ins[1]=='f')||(ins[0]=='g'&&ins[1]=='o'&&ins[2]=='t'&&ins[3]=='o')){
				string s="";
				for(int x=ins.length()-1;x>=0;x--){
					if(ins[x]==' '){
						break;
					}
					s+=ins[x];
				}
				string val = "";
				for(int x = s.length()-1;x>=0;x--){
					val+=s[x];
				}
				istringstream ss(val);
				int x;
				ss>>x;
				if(!findBlock(it->first+1)){
					leaders.insert(it->first+1);
				}
				if(!findBlock(x)){
					leaders.insert(x);
				}
			}
		}
		for(map<int, string>::iterator it=instructions.begin();it!=instructions.end();it++){
			if(leaders.find(it->first)!=leaders.end()){
				leaderLineNo.push_back(make_pair(basicBlockCount,it->first));
				basicBlockCount++;
			}
		}
		cout<<"LEADERS :: "<<endl;
		for(int i=0;i<leaderLineNo.size();i++){
			cout<<"BLOCK NO :: "<<leaderLineNo[i].first<<"  STATEMENT NO :: "<<leaderLineNo[i].second<<endl;
		}
		cout<<endl;
	}

	void generate_basic_blocks(){
		basicBlocks.resize(basicBlockCount);
		for(int i=0;i<leaderLineNo.size()-1;i++){
			int bb = leaderLineNo[i].first;
			string st = instructions[leaderLineNo[i+1].second-1];
			if(st[0]=='g'&& st[1]=='o'&& st[2]=='t'&& st[3]=='o'){
				string s="";
				for(int x=st.length()-1;x>=0;x--){
					if(st[x]==' '){
						break;
					}
					s+=st[x];
				}
				string val = "";
				for(int x = s.length()-1;x>=0;x--){
					val+=s[x];
				}
				istringstream ss(val);
				int x;
				ss>>x;
				basicBlocks[bb].push_back(findBlockNo(x));
			}
			else if(st[0]=='i' && st[1]=='f'){
				basicBlocks[bb].push_back(bb+1);
				string s="";
				for(int x=st.length()-1;x>=0;x--){
					if(st[x]==' '){
						break;
					}
					s+=st[x];
				}
				string val = "";
				for(int x = s.length()-1;x>=0;x--){
					val+=s[x];
				}
				istringstream ss(val);
				int x;
				ss>>x;
				basicBlocks[bb].push_back(findBlockNo(x));	
			}
			else{
				basicBlocks[bb].push_back(bb+1);
			}
		}
		cout<<"BASIC BLOCKS :: "<<endl;
		for(int i=0;i<basicBlocks.size();i++){
			cout<<i<<" :: ";
			for(int j=0;j<basicBlocks[i].size();j++){
				cout<<basicBlocks[i][j]<<" ";
			}
			cout<<endl;
		}
		cout<<endl;
	}

%}


%union{
	char * str;
	struct Node * nn;
	struct NodeDec * nd;
}


%token <str> TYPE ID VAL AND OR NOT LT GT EQQ LTE GTE PL MI MUL DIV OP CL OCB CCB OSB CSB EQ COMMA SEMICOLON IF ELSE WHILE TRUE FALSE NTE
%type <nd> VARIABLES ARR
%type <nn> A L R E T F M N BOOLEAN ST D I IE W st
%type <str> RELOP HMM

%%

start : ST{
			for(map<int, string>::iterator it=instructions.begin();it!=instructions.end();it++){
				cout<<it->first<<" "<<it->second<<endl;
			}
			generate_leaders();
			generate_basic_blocks();
		};

ST : {block++;} OCB st CCB{
			//showBlock();
			$$=new node();
			$$->nextList=$3->nextList;
			block--;
		}
	| D{type="";$$=new node();$$->nextList=$1->nextList;}
	| A{$$=new node();$$->nextList=$1->nextList;}
	| I{$$=new node();$$->nextList=$1->nextList;}
	| IE{$$=new node();$$->nextList=$1->nextList;}
	| W{$$=new node();$$->nextList=$1->nextList;};

st : st M ST{
			$$=new node();
			bp($1->nextList,$2->ins);
			$$->nextList=$3->nextList;
		}
	| ST{
			$$->nextList=$1->nextList;
		}
	|{};

I : IF OP BOOLEAN CL M ST{
		$$=new node();
		bp($3->trueList,$5->ins);
		$$->nextList=mergeVectors($3->falseList,$6->nextList);
	};

IE : IF OP BOOLEAN CL M ST ELSE N M ST{
				$$=new node();
				bp($3->trueList,$5->ins);
				bp($3->falseList,$9->ins);
				$$->nextList=mergeVectors($6->nextList,$8->nextList);
				$$->nextList=mergeVectors($$->nextList,$10->nextList);
			};

W : WHILE M OP BOOLEAN CL M ST{
				$$=new node();
				bp($4->trueList,$6->ins);
				bp($7->nextList,$2->ins);
				ostringstream ss;
				ss<<$2->ins;
				instructions[getIns()]="goto "+ss.str();
				$$->nextList=$4->falseList;
		};

D : TYPE {type=$1;} VARIABLES{$$=makeNode();};

VARIABLES : ID ARR COMMA VARIABLES{
					checkId($1);
					$$ = makeNodeDec();
					$$->type = type;
					$$->value="";
					$$->index = $2->index;
					symboltable[block][$1]=$$;
				}
			| ID ARR EQ HMM COMMA VARIABLES{
					checkId($1);
					$$ = makeNodeDec();
					$$->type = type;
					$$->value=$4;
					$$->index = $2->index;
					symboltable[block][$1]=$$;
				}
			| ID ARR SEMICOLON{
					checkId($1);
					$$ = makeNodeDec();
					$$->type = type;
					$$->value="";
					$$->index = $2->index;
					symboltable[block][$1]=$$;
				}
			| ID ARR EQ HMM SEMICOLON{
					checkId($1);
					$$ = makeNodeDec();
					$$->type = type;
					$$->value=$4;
					$$->index = $2->index;
					symboltable[block][$1]=$$;
				};

HMM : ID{$$=$1;}
	 | VAL{$$=$1;};

ARR : OSB VAL CSB ARR{
				$$=makeNodeDec();
				$$->index.push_back($2);
				for(int i=0;i<$4->index.size();i++)	{
					$$->index.push_back($4->index[i]);
				}
			}
		| {$$=makeNodeDec();};

A : L EQ R SEMICOLON{instructions[getIns()]=$1->name+"["+$1->code+"]= "+$3->code;}
	| ID EQ R SEMICOLON{
			checkDeclared($1);
			instructions[getIns()]=(string)$1+" = "+$3->code;
	  		$$=new Node();
		};

L : ID OSB E CSB{
			$$=makeNode();
			$$->name=$1;
			checkDeclared($1);
			$$->type=getType($1);
			$$->index=getIndex($1);
			int w;
			if($$->type=="int" || $$->type=="float"){w=4;}else{w=1;}
			for(int i=1;i<$$->index.size();i++){	stringstream geek($$->index[i]); int x=0; geek>>x; w*=x;	}
			ostringstream ss;
			ss<<w;
			instructions[getIns()]=$$->code+" = "+$3->code+" * "+ss.str();
		}
	| L OSB E CSB{
			Node * myTemp=makeNode();
 			$$=makeNode();
 			$$->name=$1->name;
 			$$->type=$1->type;
 			$$->index=$1->index;
 			$$->index.erase($$->index.begin());
 			int w;
			if($$->type=="int" || $$->type=="float"){w=4;}else{w=1;}
			for(int i=1;i<$$->index.size();i++){	stringstream geek($$->index[i]); int x=0; geek>>x; w*=x;	}
			ostringstream ss;
			ss<<w;
 			instructions[getIns()]=myTemp->code + " = "+$3->code +" * "+ss.str();
 			instructions[getIns()]=$$->code+" = "+$1->code+ " + " + myTemp->code;
		};

R : E{$$=$1;};

E : L{$$=makeNode();instructions[getIns()]=$$->code+" = "+$1->name+"["+$1->code+"]";}
	| E PL T{$$=makeNode();instructions[getIns()]=$$->code+" = "+$1->code+" + "+$3->code;}
	| E MI T{$$=makeNode();instructions[getIns()]=$$->code+" = "+$1->code+" - "+$3->code;};
	| T{$$=$1;};

T : L{$$=makeNode();instructions[getIns()]=$$->code+" = "+$1->name+"["+$1->code+"]";}
	| T MUL F{$$=makeNode();instructions[getIns()]=$$->code+" = "+$1->code+" * "+$3->code;}
	| T DIV F{$$=makeNode();instructions[getIns()]=$$->code+" = "+$1->code+" / "+$3->code;}
	| F{$$=$1;};

F : L{$$=makeNode();instructions[getIns()]=$$->code+" = "+$1->name+"["+$1->code+"]";}
	|ID{
			checkDeclared($1);
			$$=makeNode2($1);
		}
	| VAL{
			$$=makeNode2($1);
		}
	| OP E CL{$$=$2;}
	| MI F{$$=makeNode();instructions[getIns()]=$$->code+" = - "+$2->code;};

M : {$$=new node();$$->ins=ins;};

N : {$$=new node();$$->nextList.push_back(getIns());instructions[$$->nextList.back()]="goto ";};

BOOLEAN : BOOLEAN OR M BOOLEAN{
					$$=new node();
					bp($1->falseList,$3->ins);
					$$->trueList=mergeVectors($1->trueList,$4->trueList);
					$$->falseList=$4->falseList;
				}
			| BOOLEAN AND M BOOLEAN{
					$$=new node();
	 				bp($1->trueList,$3->ins);
	 				$$->trueList=$4->trueList;
	 				$$->falseList=mergeVectors($1->falseList,$4->falseList);
				}
			| NOT BOOLEAN{
					$$=new node();
					$$->trueList=$2->falseList;
					$$->falseList=$2->trueList;
				}
			| OP BOOLEAN CL{
					$$=new node();
					$$->trueList=$2->trueList;
					$$->falseList=$2->falseList;
				}
			| E RELOP E{
					$$=new node();
					$$->trueList.push_back(getIns());
					instructions[$$->trueList.back()]="if "+$1->code+" "+$2+" "+$3->code+" goto ";
					$$->falseList.push_back(getIns());
					instructions[$$->falseList.back()]="goto ";
				}
			| TRUE{$$=new node();$$->trueList.push_back(getIns());instructions[$$->trueList.back()]="goto ";}
			| FALSE{$$=new node();$$->falseList.push_back(getIns());instructions[$$->falseList.back()]="goto ";};

RELOP : LT{$$=$1;}
		| GT{$$=$1;}
		| LTE{$$=$1;}
		| GTE{$$=$1;}
		| EQQ{$$=$1;}
		| NTE{$$=$1;};

%%

void yyerror(char* s)
{
	cout<<s<<endl;
}
int yywrap(){	return 1;	}
int main()
{
	yyparse();
}

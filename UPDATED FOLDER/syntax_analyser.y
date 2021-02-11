%{
	#include <bits/stdc++.h>
	using namespace std;
	#include "SymbolTable.h"
	int yylex();
	void yyerror(string);
	#define YYSTYPE string
	extern int yylineno;
	extern int scope;
	vector<string> vars;
	vector<string> vals;
%}

%token T_Break T_For T_Func T_Import T_Package T_Return T_Var T_Fmt T_Main T_Int T_Float T_Double T_Bool T_Inc T_Dec T_Relop T_Paren T_Dims T_Brace T_Id T_Num T_String T_And T_Or T_Not T_Assgnop T_True T_False

%left '+' '-'
%left '*' '/'
%left '(' ')'

%%

PROG   	: T_Package T_Main Stmts MAIN Stmts { cout << "Valid\n"; }
		;

MAIN	: T_Func T_Main T_Paren '{' Stmts '}'
		;

Stmts	: 
		| ASSIGN Stmts
		| UNARY_EXP Stmts
		| DECL Stmts
		| '{' Stmts '}'
		;

TYPE	: T_Int
		| T_Float
		| T_Double
		| T_String
		;
VALUE 	: EXPR 
		| T_Id 
		| T_Num
		| T_String
		;

DECL	: T_Var LISTVAR TYPE '=' LISTVALUE ';' 		{ for(int i = 0; i < vars.size(); i++) insert(vars[i], $3, yylineno, vals[i], scope); vars.clear(); vals.clear();}
		| T_Var LISTVAR TYPE ';' 					{ for(int i = 0; i < vars.size(); i++) insert(vars[i], $3, yylineno, "\0", scope); vars.clear(); }
		;

LISTVAR	: T_Id										{ vars.push_back($1); }
		| T_Id { vars.push_back($1); } ',' LISTVAR
		;

LISTVALUE	: VALUE									{ vals.push_back($1); }
			| VALUE { vals.push_back($1); } ',' LISTVALUE
			;

ASSIGN  : T_Id '=' VALUE ';'						{ if(not check_decl($1, scope)) { yyerror($1 + " not declared"); exit(1); } }
		;

EXPR 	: BOOL_EXPR
		| ARITH_EXPR
		;

ARITH_EXPR 		: ARITH_EXPR '+' T | ARITH_EXPR '-' T | T
				;
T				: T '*' F | T '/' F | T '%' F | F
				;
F				: '-' T_Num 
				| '-' T_Id  
				| T_Num
				| T_Id
				| '(' ARITH_EXPR ')'
				;

BOOL_EXPR		: LOGICAL | RELATIONAL
				;
RELATIONAL		: ARITH_EXPR T_Relop ARITH_EXPR | '(' RELATIONAL ')' | ARITH_EXPR
				;
LOGICAL			: BOOL_EXPR T_Or X | X
				;
X				: X T_And Y | Y
				;
Y				: '!' Y | Z
				;
Z				: T_True | T_False | '(' LOGICAL ')' | RELATIONAL
				;

UNARY_EXP 		: T_Id T_Inc ';'
			  	| T_Inc T_Id ';'
			  	| T_Id T_Dec ';'
			  	| T_Dec T_Id ';'
			  	;

%%

void yyerror(string s)
{
	cout << s << "\n";
}

int main()
{
	yyparse();
	cout << "id\ttype\tline\tvalue\tscope\n";
	disp();
	return 0;
}


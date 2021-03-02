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

%token T_Break T_For T_Func T_Import T_Package T_Return T_Var T_Fmt T_Main T_Int T_Float T_Double T_Bool T_String T_Inc T_Dec T_Relop T_For_Init T_Assgnop T_True T_False T_And T_Or T_Paren T_Dims T_Brace T_Id T_Num T_Not

%left '+' '-'
%left '*' '/'
%left '(' ')'

%%

PROG   			: T_Package T_Main Stmts MAIN Stmts 												{ cout << "\nValid Program\n\n"; }
				;

MAIN			: T_Func T_Main T_Paren '{' Stmts '}'
				;

Stmts			: 
				| DECL Stmts
				| ASSIGN ';' Stmts
				| UNARY_EXPR ';' Stmts
				| '{' Stmts '}'
				| LOOP Stmts
				;

TYPE			: T_Int
				| T_Float
				| T_Double
				| T_Bool
				| T_String
				;

VALUE 			: EXPR | UNARY_EXPR
				| T_String
				;

DECL			: T_Var LISTVAR TYPE '=' LISTVALUE ';'
					{
						if(vars.size() != vals.size())
						{
							yyerror("Mismatch in line " + to_string(yylineno) + ": " + to_string(vars.size()) + " variables " + to_string(vals.size()) + " values");
							exit(1);
						}
						for(int i = 0; i < vars.size(); i++)
						{
							int lineno;
							if(lineno = check_decl(vars[i], scope))
							{
								yyerror(vars[i] + " redeclared in line " + to_string(yylineno) + "\nPrevious declaration in line " + to_string(lineno));
								exit(1);
							}
							insert(vars[i], $3, yylineno, vals[i], scope);
						}
						vars.clear();
						vals.clear();
				}
				| T_Var LISTVAR TYPE ';'
					{
						for(int i = 0; i < vars.size(); i++)
						{
							int lineno;
							if(lineno = check_decl(vars[i], scope))
							{
								yyerror(vars[i] + " redeclared in line " + to_string(yylineno) + "\nPrevious declaration in line " + to_string(lineno));
								exit(1);
							}
							insert(vars[i], $3, yylineno, "\0", scope);
						}
						vars.clear();
				}
				;

LISTVAR			: T_Id																				{ vars.push_back($1); }
				| T_Id { vars.push_back($1); } ',' LISTVAR
				;

LISTVALUE		: VALUE																				{ vals.push_back($1); }
				| VALUE { vals.push_back($1); } ',' LISTVALUE
				;

ASSIGN  		: T_Id '=' VALUE
					{
						if(not check_decl($1, scope))
						{
							yyerror($1 + " not declared in line " + to_string(yylineno));
							exit(1);
						}
				}
				| T_Id T_Assgnop VALUE
					{
						if(not check_decl($1, scope))
						{
							yyerror($1 + " not declared in line " + to_string(yylineno));
							exit(1);
						}
				}
				;

EXPR 			: BOOL_EXPR
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

RELATIONAL		: ARITH_EXPR T_Relop ARITH_EXPR
				| '(' RELATIONAL ')'
				;

LOGICAL			: LOGICAL T_Or X | X
				;
X				: X T_And Y | Y
				;
Y				: '!' Y | Z
				;
Z				: T_True
				| T_False
				;

UNARY_EXPR 		: T_Id T_Inc
			  	| T_Inc T_Id
			  	| T_Id T_Dec
			  	| T_Dec T_Id
			  	;

LOOP			: FOR | WHILE
				;

WHILE			: T_For BOOL_EXPR '{' Stmts '}'
				| T_For '{' Stmts '}'
				;

POST			: UNARY_EXPR
				| ASSIGN
				;

FOR				: T_For T_Id T_For_Init VALUE { insert($2, "int", yylineno, $4, scope + 1); } ';' BOOL_EXPR ';' POST '{' Stmts '}'
				;

%%

void yyerror(string s)
{
	cout << s << "\n";
}

int main()
{
	cout << "Tokens:\n";
	yyparse();
	cout << "Symbol Table:\nid\ttype\tline\tscope\n";
	disp();
	cout << "\n";
	return 0;
}


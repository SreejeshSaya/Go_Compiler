%{
	#include <bits/stdc++.h>
	using namespace std;
	#include "SymbolTable.h"
	#include "attributes.h"
	int yylex();
	void yyerror(string);
	string newtemp();
	string newlabel();
	#define YYSTYPE ATTRIBUTES
	extern int yylineno;
	int scope = 0;
	vector<string> vars;
	vector<string> codes;
	vector<string> addrs;
	vector<double> vals;
	string start;
%}

%token T_Break T_For T_Func T_Import T_Package T_Return T_Var T_Fmt T_Main T_Int T_Float T_Double T_Bool T_String T_Inc T_Dec T_Relop T_For_Init T_Assgnop T_True T_False T_And T_Or T_Paren T_Dims T_Brace T_Id T_Num T_Not

%left '+' '-'
%left '*' '/'
%left '(' ')'

%%

PROG   			: T_Package T_Main Stmts MAIN Stmts
					{ 
						cout << "\nValid Program\n\n";
						$$.code = $3.code + "\n" + $4.code + "\n" + $5.code + "\n";
						cout << "Code:" << $$.code << "\n\n";
				}
				;

MAIN			: T_Func T_Main T_Paren '{' { ++scope; } Stmts '}' { --scope; }
					{
						$$.code = $6.code + "\n";
				}
				;

Stmts			: 
				| DECL Stmts
					{ $$.code = $1.code + "\n" + $2.code + "\n"; }
				| ASSIGN ';' Stmts
					{ $$.code = $1.code + "\n" + $3.code + "\n"; }
				| UNARY_EXPR ';' Stmts
					{ $$.code = $1.code + "\n" + $3.code + "\n"; }
				| LOOP Stmts
					{ $$.code = $1.code + "\n" + $2.code + "\n"; }
				;

TYPE			: T_Int
				| T_Float
				| T_Double
				| T_Bool
				| T_String
				;

VALUE 			: EXPR 
					{
						$$.val = $1.val;
						$$.addr = $1.addr;
						$$.code = $1.code + "\n";
				}
				| UNARY_EXPR
					{
						$$.val = $1.val;
				}
				| T_String
					{
						$$.strval = $1.strval;
				}
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
							// $$.code += vars[i] + " = " + to_string(vals[i]) + "\n";
							$$.code += codes[i] + "\n" + vars[i] + " = " + addrs[i] + "\n";
							insert(vars[i], $3.strval, yylineno, vals[i], scope);
						}
						vars.clear();
						vals.clear();
						codes.clear();
						addrs.clear();
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
							insert(vars[i], $3.strval, yylineno, 0, scope);
						}
						vars.clear();
				}
				;

LISTVAR			: T_Id																				{ vars.push_back($1.strval); }
				| T_Id { vars.push_back($1.strval); } ',' LISTVAR
				;

LISTVALUE		: VALUE																				{ vals.push_back($1.val); codes.push_back($1.code); addrs.push_back($1.addr); }
				| VALUE { vals.push_back($1.val); codes.push_back($1.code); addrs.push_back($1.addr); } ',' LISTVALUE
				;

ASSIGN  		: T_Id '=' VALUE
					{
						if(not check_decl($1.strval, scope))
						{
							yyerror($1.strval + " not declared in line " + to_string(yylineno));
							exit(1);
						}
						$$.code = $3.code + "\n" + $1.strval + " = " + $3.addr + "\n";
				}
				| T_Id T_Assgnop VALUE
					{
						if(not check_decl($1.strval, scope))
						{
							yyerror($1.strval + " not declared in line " + to_string(yylineno));
							exit(1);
						}
						// $$.code = $1.strval + " = " $1.strval + " " + $2.strval + " " + $3.val + "\n";
				}
				;

EXPR 			: BOOL_EXPR
					{
						$$.code = $1.code + "\n";
				}
				| ARITH_EXPR
					{
						$$.val = $1.val;
						$$.addr = $1.addr;
						$$.code = $1.code + "\n";
				}
				;

ARITH_EXPR 		: ARITH_EXPR '+' T 
					{
						$$.val = $1.val + $3.val;
						$$.addr = newtemp();
						$$.code = $1.code + "\n" + $3.code + "\n" + $$.addr + " = " + $1.addr + " + " + $3.addr + "\n";
				}
				| ARITH_EXPR '-' T 
					{
						$$.val = $1.val - $3.val;
						$$.addr = newtemp();
						$$.code = $1.code + "\n" + $3.code + "\n" + $$.addr + " = " + $1.addr + " - " + $3.addr + "\n";
				}
				| T
					{
						$$.val = $1.val;
						$$.addr = $1.addr;
						$$.code = $1.code + "\n";
				}
				;
T				: T '*' F 
					{
						$$.val = $1.val * $3.val;
						$$.addr = newtemp();
						$$.code = $1.code + "\n" + $3.code + "\n" + $$.addr + " = " + $1.addr + " * " + $3.addr + "\n";
				}
				| T '/' F 
					{
						$$.val = $1.val / $3.val;
						$$.addr = newtemp();
						$$.code = $1.code + "\n" + $3.code + "\n" + $$.addr + " = " + $1.addr + " / " + $3.addr + "\n";
				}
				| T '%' F 
				| F
					{
						$$.val = $1.val;
						$$.addr = $1.addr;
						$$.code = $1.code + "\n";
				}
				;
F				: '-' T_Num
					{
						$$.val = -$2.val;
						$$.addr = newtemp();
						$$.code = $$.addr + " = - " + to_string($2.val) + "\n"; 
				}
				| '-' T_Id
						{
							if(not check_decl($2.strval, scope))
							{
								yyerror($2.strval + " not declared in line " + to_string(yylineno));
								exit(1);
							}
							$$.val = -$2.val;
							$$.addr = newtemp();
							$$.code = $$.addr + " = - " + $2.strval + "\n";
				}
				| T_Num
					{
						$$.val = $1.val;
						$$.addr = newtemp();
						$$.code = $$.addr + " = " + to_string($1.val) + "\n"; 
				}
				| T_Id
					{
						if(not check_decl($1.strval, scope))
						{
							yyerror($1.strval + " not declared in line " + to_string(yylineno));
							exit(1);
						}
						$$.val = $1.val;
						$$.addr = newtemp();
						$$.code = $$.addr + " = " + $1.strval + "\n"; 
				}
				| '(' ARITH_EXPR ')'
					{
						$$.val = $2.val;
						$$.addr = $2.addr;
						$$.code = $2.code + "\n";
				}
				;

BOOL_EXPR		: LOGICAL 
				| RELATIONAL
					{
						$$.code = $1.code + "\n";
						cout << $1.code << "BOOL";	
				}
				;

RELATIONAL		: ARITH_EXPR T_Relop ARITH_EXPR
					{
						$$.addr = newtemp();
						$$.code = $1.code + "\n" + $3.code + "\n" + $$.addr + " = " + $1.addr + $2.strval + $3.addr + "\n" + "if " + $$.addr + " goto " + $$.True + "\n";
				}
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
						{
							if(not check_decl($1.strval, scope))
							{
								yyerror($1.strval + " not declared in line " + to_string(yylineno));
								exit(1);
							}
				}
			  	| T_Inc T_Id
			  			{
							if(not check_decl($2.strval, scope))
							{
								yyerror($2.strval + " not declared in line " + to_string(yylineno));
								exit(1);
							}
				}
			  	| T_Id T_Dec
			  			{
							if(not check_decl($1.strval, scope))
							{
								yyerror($1.strval + " not declared in line " + to_string(yylineno));
								exit(1);
							}
				}
			  	| T_Dec T_Id
			  			{
							if(not check_decl($2.strval, scope))
							{
								yyerror($2.strval + " not declared in line " + to_string(yylineno));
								exit(1);
							}
				}
			  	;

LOOP			: FOR 
					{
						$$.code = $1.code + "\n";	
				}
				| WHILE
					{
						$$.code = $1.code + "\n";
				}
				;

WHILE			: T_For BOOL_EXPR { $2.True = newlabel(); start = newlabel(); } '{' { ++scope; } Stmts '}' { --scope; $$.code = start + ": " + "\n" + $2.code + "\n" + $2.True + "\n" + $4.code + "\n" + "goto " + start + "\n"; }
				| T_For '{' { ++scope; } Stmts '}' { --scope; }
				;

POST			: UNARY_EXPR
				| ASSIGN
				;

FOR				: T_For T_Id T_For_Init VALUE { insert($2.strval, "int", yylineno, $4.val, ++scope); } ';' BOOL_EXPR ';' POST '{' Stmts '}' { --scope; }
				;

%%

void yyerror(string s)
{
	cout << "\n\n" << s << "\n\n";
}

string newtemp()
{
	static int i = 0;
	++i;
	return "t" + to_string(i);
}

string newlabel()
{
	static int i = 0;
	++i;
	return "L" + to_string(i);
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

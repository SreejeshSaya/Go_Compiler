
%{
#include<stdio.h>
int yylex();
void yyerror(char *s);
%}

%token ID NUM FLOAT INT CHAR IF T_LT T_LTE T_GT T_GTE T_EQ T_NEQ T_AND T_OR
%%
PROG   	: Stmts
		;
Stmts	: Decl
		| IF '(' ID ')' '{' Stmts '}'
		;
Decl   	: Type ListVar ';'
	   	;
Type	: INT
		| FLOAT
		| CHAR
		;
ListVar	: ID
		| ListVar ',' ID
		;  
%%
void yyerror(char *s)
{
	printf("%s\n",s);
}
int main()
{
	yyparse();
	return 0;
}

%{
	#include <bits/stdc++.h>
	using namespace std;
	#define YYSTYPE string
	#include "y.tab.h"
	extern YYSTYPE yylval;
	int scope = 0;
%}

/* Regular Definitions */
digit		[0-9]
letter		[a-zA-Z]
id			{letter}({letter}|{digit})*
digits		{digit}+
opFraction	(\.{digits})?
opExponent	([Ee][+-]?{digits})?
number		{digits}{opFraction}{opExponent}
string		\"(\\.|[^"\\])*\"

%option yylineno

%%

\/\/.*\n			{ ; }
\/\*(.|\n)*\*\/		{ ; }

"break"				{ return T_Break; }
"for"				{ return T_For; }
"func"				{ return T_Func; }
"import"			{ return T_Import; }
"package"			{ return T_Package; }
"return"			{ return T_Return; }
"var"				{ yylval = yytext; return T_Var; }

"\"fmt\""			{ return T_Fmt; }
"main"				{ return T_Main; }

"int"				{ yylval = yytext; return T_Int; }
"float32"			{ yylval = yytext; return T_Float; }
"float64"			{ yylval = yytext; return T_Double; }
"bool"				{ yylval = yytext; return T_Bool; }
"string"			{ yylval = yytext; return T_String; }

"+"					{ return '+'; }
"-"					{ return '-'; }
"*"					{ return '*'; }
"/"					{ return '/'; }
"%"					{ return '%'; }
"++"				{ return T_Inc; }
"--"				{ return T_Dec; }

"=="|"!="|">"|"<"|">="|"<="	{ return T_Relop; }

"="					{ return '='; }
"+="|"-="|"*="|"/="	{ return T_Assgnop; }

"true"				{ return T_True; }
"false"				{ return T_False; }

"&&"				{ return T_And; }
"||"				{ return T_Or; }
"!"					{ return '!'; }

";"					{ return ';'; }
","					{ return ','; }
"."					{ return '.'; }

"["					{ return '['; }
"]"					{ return ']'; }
"("					{ return '('; }
")"					{ return ')'; }
"{"					{ ++scope; return '{'; }
"}"					{ --scope; return '}'; }
"()"				{ return T_Paren; }
"[]"				{ return T_Dims; }
"{}"				{ return T_Brace; }

{id}				{ yylval = yytext; return T_Id; }
{number}			{ yylval = yytext; return T_Num; }
{string}			{ yylval = yytext; return T_String; }
[ |\t|\n]			{ ; }
.					{ return *yytext; }

%%

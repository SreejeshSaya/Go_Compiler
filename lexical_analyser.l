%{
	#include <cstdio>
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

\/\/.*\n			{ cout << "\n"; }
\/\*(.|\n)*\*\/		{ cout << "\n"; }

"break"				{ cout << "T_Break"; return T_Break; }
"for"				{ cout << "T_For"; return T_For; }
"func"				{ cout << "T_Func"; return T_Func; }
"import"			{ cout << "T_Import"; return T_Import; }
"package"			{ cout << "T_Package"; return T_Package; }
"return"			{ cout << "T_Return"; return T_Return; }
"var"				{ cout << "T_Var"; yylval = yytext; return T_Var; }

"\"fmt\""			{ cout << "T_Fmt"; return T_Fmt; }
"main"				{ cout << "T_Main"; return T_Main; }

"int"				{ cout << "T_Int"; yylval = yytext; return T_Int; }
"float32"			{ cout << "T_Float"; yylval = yytext; return T_Float; }
"float64"			{ cout << "T_Double"; yylval = yytext; return T_Double; }
"bool"				{ cout << "T_Bool"; yylval = yytext; return T_Bool; }
"string"			{ cout << "T_String"; yylval = yytext; return T_String; }

"+"					{ cout << "+"; return '+'; }
"-"					{ cout << "-"; return '-'; }
"*"					{ cout << "*"; return '*'; }
"/"					{ cout << "/"; return '/'; }
"%"					{ cout << "%"; return '%'; }
"++"				{ cout << "T_Inc"; return T_Inc; }
"--"				{ cout << "T_Dec"; return T_Dec; }

"=="|"!="|">"|"<"|">="|"<="	{ cout << "T_Relop"; return T_Relop; }

"="					{ cout << "="; return '='; }
":="				{ cout << "T_For_Init"; return T_For_Init; }
"+="|"-="|"*="|"/="	{ cout << "T_Assgnop"; return T_Assgnop; }

"true"				{ cout << "T_True"; return T_True; }
"false"				{ cout << "T_False"; return T_False; }

"&&"				{ cout << "T_And"; return T_And; }
"||"				{ cout << "T_Or"; return T_Or; }
"!"					{ cout << "!"; return '!'; }

";"					{ cout << ";"; return ';'; }
","					{ cout << ","; return ','; }
"."					{ cout << "."; return '.'; }

"["					{ cout << "["; return '['; }
"]"					{ cout << "]"; return ']'; }
"("					{ cout << "("; return '('; }
")"					{ cout << ")"; return ')'; }
"{"					{ cout << "{"; ++scope; return '{'; }
"}"					{ cout << "}"; --scope; return '}'; }
"()"				{ cout << "T_Paren"; return T_Paren; }
"[]"				{ cout << "T_Dims"; return T_Dims; }
"{}"				{ cout << "T_Brace"; return T_Brace; }

{id}				{ cout << "T_Id"; yylval = yytext; return T_Id; }
{number}			{ cout << "T_Num"; yylval = yytext; return T_Num; }
{string}			{ cout << "T_String"; yylval = yytext; return T_String; }
[ |\t|\n]			{ cout << yytext; }
.					{ return *yytext; }

%%

%{
	#include <cstdio>
	#include <bits/stdc++.h>
	using namespace std;
	#include "attributes.h"
	#define YYSTYPE ATTRIBUTES
	#include "y.tab.h"
	extern YYSTYPE yylval;
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
"var"				{ cout << "T_Var"; yylval.strval = yytext; return T_Var; }

"\"fmt\""			{ cout << "T_Fmt"; return T_Fmt; }
"main"				{ cout << "T_Main"; return T_Main; }

"int"				{ cout << "T_Int"; yylval.strval = yytext; return T_Int; }
"float32"			{ cout << "T_Float"; yylval.strval = yytext; return T_Float; }
"float64"			{ cout << "T_Double"; yylval.strval = yytext; return T_Double; }
"bool"				{ cout << "T_Bool"; yylval.strval = yytext; return T_Bool; }
"string"			{ cout << "T_String"; yylval.strval = yytext; return T_String; }

"+"					{ cout << "+"; return '+'; }
"-"					{ cout << "-"; return '-'; }
"*"					{ cout << "*"; return '*'; }
"/"					{ cout << "/"; return '/'; }
"%"					{ cout << "%"; return '%'; }
"++"				{ cout << "T_Inc"; return T_Inc; }
"--"				{ cout << "T_Dec"; return T_Dec; }

"=="|"!="|">"|"<"|">="|"<="	{ cout << "T_Relop"; yylval.strval = yytext; return T_Relop; }

"="					{ cout << "="; return '='; }
":="				{ cout << "T_For_Init"; return T_For_Init; }
"+="|"-="|"*="|"/="	{ cout << "T_Assgnop"; yylval.strval = yytext[0]; return T_Assgnop; }

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
"{"					{ cout << "{"; return '{'; }
"}"					{ cout << "}"; return '}'; }
"()"				{ cout << "T_Paren"; return T_Paren; }
"[]"				{ cout << "T_Dims"; return T_Dims; }
"{}"				{ cout << "T_Brace"; return T_Brace; }

{id}				{ cout << "T_Id"; yylval.strval = yytext; return T_Id; }
{number}			{ cout << "T_Num"; yylval.val = stof(yytext); return T_Num; }
{string}			{ cout << "T_String"; yylval.strval = yytext; return T_String; }
[ |\t|\n]			{ cout << yytext; }
.					{ return *yytext; }

%%

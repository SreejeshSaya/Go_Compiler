%{
	int line_number = 1;
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
line		\n

%%

{line}				{ ++line_number; printf("\n"); }

\/\/.*\n			{ ; }
\/\*(.|\n)*\*\/		{ ; }

"break"				{ printf("BREAK\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
"case"				{ printf("CASE\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
"chan"				{ printf("CHAN\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
"const"				{ printf("CONST\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
"continue"			{ printf("CONTINUE\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
"default"			{ printf("DEFAULT\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
"defer"				{ printf("DEFER\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
"else"				{ printf("ELSE\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
"fallthrough"		{ printf("FALLTHROUGH\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
"for"				{ printf("FOR\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
"func"				{ printf("FUNC\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
"go"				{ printf("GO\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
"goto"				{ printf("GOTO\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
"if"				{ printf("IF\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
"import"			{ printf("IMPORT\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
"interface"			{ printf("INTERFACE\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
"map"				{ printf("MAP\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
"package"			{ printf("PACKAGE\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
"range"				{ printf("RANGE\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
"return"			{ printf("RETURN\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
"select"			{ printf("SELECT\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
"struct"			{ printf("STRUCT\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
"switch"			{ printf("SWITCH\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
"type"				{ printf("TYPE\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }

"var"				{ printf("VAR\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
"int"				{ printf("INT\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
"float32"			{ printf("FLOAT32\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
"float64"			{ printf("FLOAT64\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
"bool"				{ printf("BOOL\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }

\+					{ printf("PLUSOP\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
\-					{ printf("MINUSOP\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
\*					{ printf("MULTOP\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
\/					{ printf("DIVOP\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
\%					{ printf("MODOP\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }

\<					{ printf("LT\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
\<=					{ printf("LTE\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
\>					{ printf("GT\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
\>=					{ printf("GTE\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
=					{ printf("GETS\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
==					{ printf("EQ\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
!=					{ printf("NEQ\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }

"true"				{ printf("TRUE\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
"false"				{ printf("FALSE\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }

&&					{ printf("AND\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
\|\|				{ printf("OR\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
!					{ printf("NOT\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }

;					{ printf("SEMICOLON\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
,					{ printf("COMMA\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
\.					{ printf("DOT\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }

\[					{ printf("LSQB\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
\]					{ printf("RSQB\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
\(					{ printf("LPAR\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
\)					{ printf("RPAR\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
\{					{ printf("LCURL\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
\}					{ printf("RCURL\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
\(\)				{ printf("PAR\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
\[\]				{ printf("SQ\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
\{\}				{ printf("CURL\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }

{id}				{ printf("ID\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
{number}			{ printf("NUM\t"); printf("%2d\t", line_number); printf("%s\n", yytext); }
{string}			{ printf("STRING\t"); printf("%2d\t", line_number); printf("%s\n\n", yytext); }
[ |\t|\n]			{ ; printf("%s\n", yytext); }

%%

int main()
{
	printf("Token\tLineNo\tLexeme\n\n");
	yylex();
	printf("\n");
}

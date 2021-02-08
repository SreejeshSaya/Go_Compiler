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

{line}				{ printf("\n"); ++line_number; }
\/\/.*\n			{ printf("%d comment\n", line_number++); }
\/\*(.|\n)*\*\/		{ printf("comment"); }
"break"				{ printf("BREAK"); }
"case"				{ printf("CASE"); }
"chan"				{ printf("CHAN"); }
"const"				{ printf("CONST"); }
"continue"			{ printf("CONTINUE"); }
"default"			{ printf("DEFAULT"); }
"defer"				{ printf("DEFER"); }
"else"				{ printf("ELSE"); }
"fallthrough"		{ printf("FALLTHROUGH"); }
"for"				{ printf("FOR"); }
"func"				{ printf("FUNC"); }
"go"				{ printf("GO"); }
"goto"				{ printf("GOTO"); }
"if"				{ printf("IF"); }
"import"			{ printf("IMPORT"); }
"interface"			{ printf("INTERFACE"); }
"map"				{ printf("MAP"); }
"package"			{ printf("PACKAGE"); }
"range"				{ printf("RANGE"); }
"return"			{ printf("RETURN"); }
"select"			{ printf("SELECT"); }
"struct"			{ printf("STRUCT"); }
"switch"			{ printf("SWITCH"); }
"type"				{ printf("TYPE"); }
"var"				{ printf("VAR"); }
\+					{ printf("PLUSOP"); }
\-					{ printf("MINUSOP"); }
\*					{ printf("MULTOP"); }
\/					{ printf("DIVOP"); }
\%					{ printf("MODOP"); }
\<					{ printf("LT"); }
\<=					{ printf("LTE"); }
\>					{ printf("GT"); }
\>=					{ printf("GTE"); }
=					{ printf("GETS"); }
==					{ printf("EQ"); }
!=					{ printf("NEQ"); }
"true"				{ printf("TRUE"); }
"false"				{ printf("FALSE"); }
&&					{ printf("AND"); }
\|\|				{ printf("OR"); }
!					{ printf("NOT"); }
;					{ printf("SEMICOLON"); }
,					{ printf("COMMA"); }
\.					{ printf("DOT"); }
\[					{ printf("LSQB"); }
\]					{ printf("RSQB"); }
\(					{ printf("LPAR"); }
\)					{ printf("RPAR"); }
\{					{ printf("LCURL"); }
\}					{ printf("RCURL"); }
\(\)				{ printf("PAR"); }
\[\]				{ printf("SQ"); }
\{\}				{ printf("CURL"); }
{id}				{ printf("ID"); }
{number}			{ printf("NUM"); }
{string}			{ printf("String"); }


%%

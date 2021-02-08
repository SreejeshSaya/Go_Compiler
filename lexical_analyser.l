%{
	#include <stdio.h>
	#include "y.tab.h"
%}

/* Regular Definitions */
digit		[0-9]
letter		[a-zA-Z]
id			{letter}({letter}|{digit})*
digits		{digit}+
opFraction	(\.{digits})?
opExponent	([Ee][+-]?{digits})?
number		{digits}{opFraction}{opExponent}

%%

\/\/.*\n			{ printf("comment"); }
\/\*(.|\n)*\*\/		{ printf("comment"); }

\+					{ return '+'; }
\-					{ return '-'; }
\*					{ return '*'; }
\/					{ return '/'; }
\%					{ return '%'; }
\<					{ return T_LT; }
\<=					{ return T_LTE; }
\>					{ return T_GT; }
\>=					{ return T_GTE; }
=					{ return '='; }
==					{ return T_EQ; }
!=					{ return T_NEQ; }
&&					{ return T_AND; }
\|\					{ return T_OR; }
!					{ return '!'; }
;					{ return ';'; }
,					{ return ','; }
\.					{ return '.'; }
\[					{ return '['; }
\]					{ return ']'; }
\(					{ return '('; }
\)					{ return ')'; }
\{					{ return '{'; }
\}					{ return '}'; }

%%

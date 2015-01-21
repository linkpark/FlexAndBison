/*识别计算器的记号*/

%option noyywrap nounput noinput nodefault yylineno case-insensitive
%option header-file="fb3-1.lex.h"
%{
#include "fb3-1.h"
#include "fb3-1.tab.h"
%}

/*浮点指数部分*/
EXP ([Ee][-+]?[0-9]+)

%%
\n { return EOL;}
"//".*
[ \t] {}
. { yyerror("Mystery character %c\n",*yytext);}

%%

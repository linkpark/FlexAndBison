/*识别就算器记号*/
%option noyywrap nodefault yylineno
%{
#include "fb3-2.h"
#include "fb3-2.tab.h"
%}

/* 浮点数指数部分 */

EXP ([Ee][-+]?[0-9]+)

%%
"+" |
"-" |
"*" |
"/" |
"=" |
"|" |
"," |
";" |
"(" |
")" { return yytext[0]; }

">" { yylval.fn = 1; return CMP; }
"<" { yylval.fn = 2; return CMP; }
"<>" { yylval.fn = 3; return CMP; }
"==" { yylval.fn = 4; return CMP; }
">=" { yylval.fn = 5; return CMP; }
"<=" { yylval.fn = 6; return CMP; }

"if" { return IF; }
"then" { return THEN; }
"else" { return ELSE; }
"while" { return WHILE; }
"do"  { return DO; }
"let" { return LET; }

"sqrt" { yylval.fn = bSqrt; return FUNC; }
"exp"  { yylval.fn = bExp; return FUNC; }
"log"  { yylval.fn = bLog; return FUNC; }
"print" { yylval.fn = bPrint; return FUNC; }

[a-zA-Z][a-zA-Z0-9]* { yylval.s = lookUp( yytext ); return NAME; }

[0-9]+"."[0-9]*{EXP}? |
"."?[0-9]+{EXP}? { yylval.d = atof( yytext ); return NUMBER; }

"//".*
[ \t] /*忽略空白字符*/

\\\n { printf("c> "); }

\n { return EOL; }

. { yyerror("Mystery character %c\n", *yytext); }
%%


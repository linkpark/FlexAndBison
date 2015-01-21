%option noyywrap nodefault nounput noinput yylineno case-insensitive
%option reentrant bison-bridge bison-locations
%option header-file="Calculater.lex.h"

%{
#include "Calculater.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "Node.h"

extern void yyerror(char *s, ...);

extern struct _node* newNode(NodeType type, int childNumber, ... );

%}

%option extra-type="struct _ResultPlan *"

%%
%{
    struct _ResultPlan *result = yyextra;
%}

[0-9]+ {
    Node *node = newNode( T_NUMBER, 0 );
    node->value = atoi( yytext );
    yylval->node = node;

    return NUMBER;
}


\n { return EOF;}

"//".*
[ \t] { }

<<EOF>> { return END_P;}

. {
    yyerror("Mestory charactor!\n");
}

%%




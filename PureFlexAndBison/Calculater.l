%option noyywrap nodefault nounput noinput yylineno case-insensitive
%option bison-bridge bison-locations
%option header-file="Calculater.lex.h"
%{
#include "Calculater.tab.h"
#include "Node.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>

%}

%%

[0-9]+ {
    Node *node = newNode( T_NUMBER, 0 );
    node->value = atoi( yytext );
    yylval->node = node;

    return NUMBER;
}


\n { return EOF;}

"//".*
[ \t] { }

. {
    printf("Mystery charactor!\n");
}

%%


int parseStmt( ResultPlan *p, const char* pStr, int len ){
    int ret = -1;

    p->resultTree = NULL;
    
    YY_BUFFER_STATE bp;
    
    bp = yy_scan_string( pStr );
    yy_switch_to_buffer( bp );
    ret = yyparse( p );
    yy_delete_buffer( bp );

    return ret;
}



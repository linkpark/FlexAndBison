%define api.pure full
%parse-param { struct _ResultPlan *result }
%locations

%{
#include "Node.h"

%}

%union{
    struct _node *node;
    int val;
}

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include "Calculater.lex.h"

extern void yyerror(YYLTYPE *yylloc, ResultPlan *p, const char* s );

%}
%token EOL
%token <node> NUMBER
%left '+' '-'
%left '*' '/'

%type <node> expr
%type <node> calclist
%start  calclist

%%
calclist:
        expr {
        result->resultTree = $$;
        YYACCEPT; 
        } 
        ;
expr:
    expr '+' expr{
        $$ = mallocNonTerminalNode( OP_ADD, 2, $1, $3);    
    }
    | expr '-' expr{
        $$ = mallocNonTerminalNode( OP_SUB, 2, $1, $3);
    }
    | expr '*' expr{
        $$ = mallocNonTerminalNode( OP_MUL, 2 , $1, $3);
    }
    | expr '/' expr{
        $$ = mallocNonTerminalNode( OP_DIV, 2 , $1, $3);
    }
    | NUMBER{
        $$ = $1;
    }
    ;

%%

void yyerror(YYLTYPE *yylloc, ResultPlan *p, const char* s ){
    printf("error!");
}


%define api.pure
%parse-param { struct _ResultPlan *result }

%{
#include "Node.h"

#define YYDEBUG 1

%}

%union{
    struct _node *node;
    int val;
}

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define YYLEX_PARAM node->yyscanInfo

%}

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



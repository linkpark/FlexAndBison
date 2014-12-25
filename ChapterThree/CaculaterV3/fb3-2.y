/*基于抽象语法树的计算器*/

%{
#include <stdio.h>
#include <stdlib.h>
#include "fb3-2.h"
%}

%union{
    struct AbstractSyntaxTree *ast;
    double d;
    struct Symbol *s; /* 指定符号 */
    struct SymbolList *sl;
    int functionNumber; /* 指定函数 */ 
}

/* 声明记号 */
%token <d> NUMBER
%token <s> NAME
%token <functionNumber> FUNC
%token EOL

%token IF THEN ELSE WHILE DO LET

/*定义优先级*/
%nonassoc <functionNumber> CMP
%right '='
%left '+' '-'
%left '*' '/'
%nonassoc '|' UMINUS

%type <a> exp stmt list explist
%type <sl> symlist

/*定义语法树的起点*/
%start calclist 
%%

stmt: IF exp THEN list { $$ = newFlow( 'I', $2, $4, NULL ); }
    | IF exp THEN list ELSE list { $$ = newFlow( 'I', $2, $4, $6 ); }
    | WHILE exp DO list { $$ = newFlow( 'W', $2, $4, NULL ); }
    | exp
    ;

list: /*空*/ { $$ = NULL;}
    | stmt ';' list { if ($3 == NULL)
                        $$ = $1;
                      else
                        $$ = newAbstractSyntaxTree( 'L', $1, $3 );
                    }
    ;

exp: exp CMP exp { $$ = newCompare($2, $1, $3); }
   | exp '+' exp { $$ = newAbstractSyntaxTree('+', $1, $3); }
   | exp '-' exp { $$ = newAbstractSyntaxTree('-', $1, $3); }
   | exp '*' exp { $$ = newAbstractSyntaxTree('*', $1, $3); }
   | exp '/' exp { $$ = newAbstractSyntaxTree('/', $1, $3); }
   | '|' exp { $$ = newAbstractSyntaxTree('|', $2, NULL); }
   | '(' exp ')' { $$ = $2; }
   | '-' exp %prec UMINUS { $$ = newAbstractSyntaxTree('M', $2, NULL); }
   | NUMBER { $$ = newNumberValue(); }
   | NAME { $$ = newSymbolReference( $1 ); }
   | NAME '=' exp { $$ = newSymbolAsgn( $1, $3 );}
   | FUNC '(' explist ')' { $$ = newFunctionCall( $1, $3 ); }
   | NAME '(' explist ')' { $$ = newUserFunctionCall( $1, $3 );}
   ;

explist: exp
    | exp ',' explist { $$ = newAbstractSyntaxTree('L', $1, $3); }
    ;

symlist: NAME { $$ = newSymbolList( $1, NULL ); }
    | NAME ',' symlist { $$ = newSymbolList( $1, $3 ); }
    ;

/*顶层规则*/
calclist: /* 空 */
    | calclist stmt EOL{
        printf("= %lf\n", eval($2));
        treeFree( $2 );
        }
    | calclist LET NAME '(' symlist ')' '=' list EOL{
            doDefine($3, $5, $8);
            printf("Define %s\n>", $3->name );
        }
    | calclist error EOL { yyerrok; printf("> "); }
    ;
    

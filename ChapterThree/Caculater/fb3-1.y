%{
#include <stdio.h>
#include <stdlib.h>
#include "fb3-1.h"
%}

%union {
struct ast *a;
double d;
}

/*声明记号*/
/*所以NUMBER类型为double，exp factor term类型为struct ast**/
%token <d> NUMBER 
%token EOL

%type <a> exp factor term


%%
calclist: /* 空*/
    | calclist exp EOL {
        printf("= %lf\n",eval($2));
        treefree($2);
        printf("> ");
    }

    | calclist EOL { printf("> "); } /* 空行或者注释 */
    ;

exp: factor
    | exp '+' factor { $$ = newast('+', $1, $3);}
    | exp '-' factor { $$ = newast('-', $1, $3);}
    ;

factor:term
    | factor '*' term { $$ = newast('*', $1, $3);}
    | factor '/' term { $$ = newast('/', $1, $3);}
    ;

term: NUMBER { $$ = newnum($1);}
    | '|' term { $$ = newast( '1' , $2 , NULL); }
    | '(' exp ')' { $$ = $2;}
    | '-' term { $$ = newast('M', $2, NULL);}
    ;
%%

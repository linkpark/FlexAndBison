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


%left '+' '-'
%left '*' '/'
%nonassoc '|' UMINUS

%type <a> exp


%%
calclist: /* 空*/
    | calclist exp EOL {
        printf("= %lf\n",eval($2));
        treefree($2);
        printf("> ");
    }

    | calclist EOL { printf("> "); } /* 空行或者注释 */
    ;

exp: exp '+' exp { $$ = newast('+', $1, $3);}
    | exp '-' exp { $$ = newast('-', $1, $3);}
    | exp '*' exp { $$ = newast('*', $1, $3);}
    | exp '/' exp { $$ = newast('/', $1, $3);}
    | '|' exp { $$ = newast('|', $2, NULL);}
    | '(' exp ')' { $$ = $2;}
    | '-' exp %prec UMINUS{ $$ = newast('M',NULL,$2);}
    | NUMBER {$$ = newnum($1);}
    ;
%%


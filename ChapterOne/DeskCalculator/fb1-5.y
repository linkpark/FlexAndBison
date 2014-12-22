%{
#include <stdio.h>
%}

/* declare tokens */
%token NUMBER
%token ADD SUB MUL DIV ABS
%token OP CP
%token EOL

/*
 * 这里是书写上下文无关文法BNF
 * 其中目标符号(冒号左边的语法符号)的值在代码中用$$表示
 * 右边语法符号的值依次由$1、$2 直到语法结束
 */

%%

calclist:/*空规则*/
    | calclist exp EOL { printf("= %d\n", $2); printf("= 0x%x\n", $2);}
    ;

exp: factor { $$ = $1;} 
    | exp ADD factor { $$ = $1 + $3; }
    | exp SUB factor { $$ = $1 - $3; }
    ;

factor: term  { $$ = $1; }
    | factor MUL term { $$ = $1 * $3; }
    | factor DIV term { $$ = $1 / $3; }
    ;

term: NUMBER  { $$ = $1; }
    | ABS term ABS { $$ = $2 >= 0 ? $2: -$2; }
    | OP exp CP { $$ = $2; }
    ;
%%

main(int argc, char **argv){
    yyparse();
}

yyerror( char *s){
    fprintf(stderr, "error: %s\n",s);
}


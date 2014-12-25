/*
 * fb3-2的辅助函数
 * */
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <math.h>

#include "fb3-2.h"

/* 符号表 */
/* 哈希一个符号表 */
static unsigned symbolHash( char *sym ){
    unsigned int hash = 0;
    unsigned c;

    while( (c = *sym++) )
        hash = hash * 9 ^ c;

    return hash;
}

struct Symbol *lookUp( char *sym ){
    struct Symbol *sp = &symTable[ symbolHash(sym) % NHASH ];
    int scount = NHASH;

    while( --scount >= 0 ){
        if( sp->name && !strcmp( sp->name, sym )){
            return sp;
        }

        if( !sp->name){
            sp->name = strdup(sym);
            sp->value = 0;
            sp->func = NULL;
            sp->syms = NULL;

            return sp;
        }

        if( ++sp >= symTable + NHASH)
            sp = symTable;
    }
    
    yyerror("symbol table overflow\n");
    abort();
}



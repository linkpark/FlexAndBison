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

struct AbstractSyntaxTree* newAbstractSyntaxTree( int nodeType,
        struct AbstractSyntaxTree *l, struct AbstractSyntaxTree *r){
    struct AbstractSyntaxTree *a = 
        (struct AbstractSyntaxTree*)malloc( sizeof(struct AbstractSyntaxTree) );

    if( NULL == a ){
        yyerror("out of space!");
        exit(0);
    }

    a->nodeType = nodeType;
    a->left = l;
    a->right = r;

    return a;
}

struct AbstractSyntaxTree* newNumberValue( double d ){
    struct NumberValue *a = 
        (struct NumberValue*)malloc(sizeof(struct NumberValue ));

    if( NULL == a ){
        yyerror("out of space!\n");
        exit(0);
    }

    a->nodeType = 'K';
    a->number = d;

    return (struct AbstractSyntaxTree *)a;
}

struct AbstractSyntaxTree *newCompare( int compareType, 
        struct AbstractSyntaxTree *l, struct AbstractSyntaxTree *r){
    struct AbstractSyntaxTree *a = 
        (struct AbstractSyntaxTree*)sizeof(struct AbstractSyntaxTree);
    
    if( NULL == a ){
        yyerror("out of space!");
        exit(0);
    }

    a->nodeType = '0' + compareType;
    a->left = l;
    a->right = r;

    return a;
}

struct AbstractSyntaxTree* newFunctionCall( int funcType,
        struct AbstractSyntaxTree *l){
    struct FunctionCall *a = 
        ( struct FunctionCall* )malloc( sizeof(struct FunctionCall) );
    
    if( NULL == a ){
        yyerror("out of space !");
        exit(0);
    }

    a->nodeType = 'F';
    a->left = l;
    a->funcType = funcType;

    return ( struct AbstractSyntaxTree* )a;
}

struct AbstractSyntaxTree* newUserFunctionCall( struct Symbol *s,
        struct AbstractSyntaxTree* l ){
    struct UserFunctionCall *userFuncCall = 
        (struct UserFunctionCall*)malloc( sizeof(struct UserFunctionCall) );

    if( NULL == userFuncCall ){
        yyerror("out of space!");
        exit(0);
    }

    userFuncCall->nodeType = 'C';
    userFuncCall->left = l;
    userFuncCall->symbol = s;

    return ( AbstractSyntaxTree * )userFuncCall;
}

